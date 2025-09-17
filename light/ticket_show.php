<?php
// modules/cmms/zgloszenia/show.php (LIGHT – mobile friendly, bez modala)
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';
require_once ROOT_PATH.'api/cmms/eligibility.php';

requireLogin();
requirePermission(['cmms.tickets.view','cmms.*','admin.*']);

$ZBASE = rtrim(ROOT_URL, '/').'/modules/cmms/zgloszenia/';

/** @var PDO $pdo */
$pdo = pdo();
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if (!function_exists('h')) {
  function h(?string $s): string { return htmlspecialchars((string)$s, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }
}

if (!function_exists('cmms_group_label')) {
    function cmms_group_label(PDO $pdo, ?int $id): string {
        if (!$id || $id <= 0) return '';
        $q = $pdo->prepare("SELECT COALESCE(NULLIF(TRIM(nazwa),''), NULLIF(TRIM(name),''), CONCAT('Grupa #', id)) AS label FROM cmms_group WHERE id = :id");
        $q->execute([':id'=>$id]);
        return (string)($q->fetchColumn() ?: '');
    }
}

/** hh:mm:ss bez zawijania po 24h */
function hms(int $s): string {
  $h = intdiv($s, 3600);
  $m = intdiv($s % 3600, 60);
  $ss = $s % 60;
  return sprintf('%02d:%02d:%02d', $h, $m, $ss);
}

/** Ścieżka zasobu (cmms_struktura) */
function cmms_struct_path(PDO $pdo, int $id): string {
  if ($id <= 0) return '';
  $parts = []; $cur = $id; $g = 0;
  while ($cur && $g++ < 1000) {
    $st = $pdo->prepare('SELECT id, parent_id, nazwa FROM cmms_struktura WHERE id = :id');
    $st->execute([':id'=>$cur]);
    $row = $st->fetch(PDO::FETCH_ASSOC);
    if (!$row) break;
    $parts[] = (string)$row['nazwa'];
    $cur = (int)$row['parent_id'];
  }
  return $parts ? implode(' / ', array_reverse($parts)) : '';
}

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) {
  $_SESSION['error'] = 'Brak identyfikatora zgłoszenia.';
  header('Location: ' . ROOT_URL . 'modules/cmms/zgloszenia/list.php');
  exit;
}

/** Dane zgłoszenia (pobieramy też workflow_id i grupę) */
$sql = "
  SELECT
    t.id, t.title, t.description, t.priority,
    t.status_id, t.type_id, t.subtype_id, t.struktura_id,
    t.group_id, t.responsibility_id, t.reporter_id, t.assignee_id,
    t.workflow_id,
    t.created_at, t.updated_at,

    ty.name  AS type_name,
    stp.name AS subtype_name,

    s.name   AS status_name,
    s.color  AS status_color,

    stru.nazwa AS struktura_name,

    COALESCE(
      NULLIF(TRIM(CONCAT_WS(' ', CONVERT(ur.imie USING utf8mb4), CONVERT(ur.nazwisko USING utf8mb4))), ''),
      NULLIF(CONVERT(ur.name USING utf8mb4), ''),
      CONCAT('#', t.reporter_id)
    ) AS reporter_name,

    COALESCE(
      NULLIF(TRIM(CONCAT_WS(' ', CONVERT(ua.imie USING utf8mb4), CONVERT(ua.nazwisko USING utf8mb4))), ''),
      NULLIF(CONVERT(ua.name USING utf8mb4), ''),
      IFNULL(CONCAT('#', t.assignee_id), NULL)
    ) AS assignee_name,

    COALESCE(NULLIF(TRIM(g.name),''), NULLIF(TRIM(g.name),''), CONCAT('Grupa #', g.id)) AS group_label

  FROM cmms_tickets t
  LEFT JOIN cmms_ticket_types     ty   ON ty.id  = t.type_id
  LEFT JOIN cmms_ticket_subtypes  stp  ON stp.id = t.subtype_id
  LEFT JOIN cmms_statuses         s    ON s.id   = t.status_id
  LEFT JOIN cmms_struktura        stru ON stru.id = t.struktura_id
  LEFT JOIN users                 ur   ON ur.id  = t.reporter_id
  LEFT JOIN users                 ua   ON ua.id  = t.assignee_id
  LEFT JOIN cmms_group            g    ON g.id   = t.group_id
  WHERE t.id = ?
  LIMIT 1
";
$st = $pdo->prepare($sql);
$st->execute([$id]);
$ticket = $st->fetch(PDO::FETCH_ASSOC);

if (!$ticket) {
  $_SESSION['error'] = 'Nie znaleziono zgłoszenia.';
  header('Location: ' . ROOT_URL . 'modules/cmms/zgloszenia/list.php');
  exit;
}

$pageTitle = 'Szczegóły zgłoszenia – CMMS';
$path = !empty($ticket['struktura_id']) ? cmms_struct_path($pdo, (int)$ticket['struktura_id']) : '';

/** Historia statusów (DESC) */
$histSql = "
  SELECT l.id,
         l.changed_at,
         l.comment,
         l.reason_code,
         fs.name AS from_name,
         ts.name AS to_name,
         ts.color AS to_color,
         u.id AS user_id,
         COALESCE(
           NULLIF(TRIM(CONCAT_WS(' ', CONVERT(u.imie USING utf8mb4), CONVERT(u.nazwisko USING utf8mb4))), ''),
           NULLIF(CONVERT(u.name USING utf8mb4), ''),
           CONCAT('#', u.id)
         ) AS user_name
  FROM cmms_ticket_status_log l
  LEFT JOIN cmms_statuses fs ON fs.id = l.from_status_id
  LEFT JOIN cmms_statuses ts ON ts.id = l.to_status_id
  LEFT JOIN users u          ON u.id  = l.user_id
  WHERE l.ticket_id = ?
  ORDER BY l.id DESC
  LIMIT 200
";
$hist = $pdo->prepare($histSql);
$hist->execute([$id]);
$history = $hist->fetchAll(PDO::FETCH_ASSOC);

/** Dozwolone przejścia – WF jeśli jest, inaczej globalne */
require_once ROOT_PATH.'api/cmms/status_change.php';

$workflowId = isset($ticket['workflow_id']) && $ticket['workflow_id'] !== null
  ? (int)$ticket['workflow_id']
  : cmms_resolve_workflow_id($pdo, (int)$ticket['type_id'], $ticket['subtype_id'] !== null ? (int)$ticket['subtype_id'] : null);

$transitions = [];
if ($workflowId) {
  $q = $pdo->prepare("
    SELECT
      id, workflow_id, from_status_id, to_status_id,
      COALESCE(requires_comment,0)  AS requires_comment,
      COALESCE(requires_reason,0)   AS requires_reason,
      COALESCE(requires_assignee,0) AS requires_assignee,
      NULLIF(TRIM(reason_type), '') AS reason_type,
      COALESCE(set_resolved_at,0)   AS set_resolved_at,
      COALESCE(set_closed_at,0)     AS set_closed_at,
      COALESCE(pause_sla,0)         AS pause_sla,
      COALESCE(resume_sla,0)        AS resume_sla,
      COALESCE(order_no,0)          AS sort_order
    FROM cmms_workflow_transitions
    WHERE workflow_id = :wf
      AND (from_status_id = :from OR from_status_id IS NULL OR from_status_id = 0)
    ORDER BY order_no, id
  ");
  $q->execute([':wf'=>$workflowId, ':from'=>(int)$ticket['status_id']]);
  $transitions = $q->fetchAll(PDO::FETCH_ASSOC) ?: [];
} else {
  $q = $pdo->prepare("
    SELECT id, NULL AS workflow_id, from_status_id, to_status_id
    FROM cmms_status_transitions
    WHERE (from_status_id = :from OR from_status_id IS NULL OR from_status_id = 0)
    ORDER BY id
  ");
  $q->execute([':from'=>(int)$ticket['status_id']]);
  $transitions = array_map(function($r){
    $r['requires_comment']=0;
    $r['requires_reason']=0;
    $r['requires_assignee']=0;
    $r['reason_type']=null;
    $r['set_resolved_at']=0;
    $r['set_closed_at']=0;
    $r['pause_sla']=0;
    $r['resume_sla']=0;
    return $r;
  }, $q->fetchAll(PDO::FETCH_ASSOC) ?: []);
}

/** Prefetch nazw/kolorów statusów docelowych */
$toIds = array_values(array_unique(array_map(fn($r)=> (int)$r['to_status_id'], $transitions)));
$toMap = [];
if ($toIds) {
  $in  = implode(',', array_fill(0, count($toIds), '?'));
  $qs  = $pdo->prepare("SELECT id, name, color FROM cmms_statuses WHERE id IN ($in)");
  $qs->execute($toIds);
  foreach ($qs->fetchAll(PDO::FETCH_ASSOC) as $row) {
    $toMap[(int)$row['id']] = ['name'=>$row['name'], 'color'=>$row['color']];
  }
}

/* ===== Załączniki ===== */

$canEdit = function_exists('checkAccess')
  ? checkAccess(['cmms.tickets.edit','cmms.*','admin.*'])
  : false;

$canAssignUser = function_exists('checkAccess')
  ? checkAccess(['cmms.tickets.assign','cmms.*','admin.*'])
  : false;

$uploadsBase = ROOT_URL . 'uploads/tickets/';

$files = [];
try {
  $fs = $pdo->prepare("
    SELECT id, original_name, stored_name, thumb_name, created_at
    FROM cmms_ticket_files
    WHERE ticket_id = :t
    ORDER BY id DESC
  ");
  $fs->execute([':t' => (int)$ticket['id']]);
  $files = $fs->fetchAll(PDO::FETCH_ASSOC) ?: [];
} catch (Throwable $e) {
  $files = [];
}

include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';

?>
<main class="main-content">
  <!-- CSRF do POST -->
  <meta name="csrf-token" content="<?= h(csrf_token()) ?>">

  <!-- Select2 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

  <div class="breadcrumb">
    <a href="<?= ROOT_URL ?>dashboard.php">Dashboard</a> /
    <a href="<?= ROOT_URL ?>modules/cmms/menu.php">CMMS</a> /
    <a href="<?= ROOT_URL ?>modules/cmms/zgloszenia/list.php">Zgłoszenia</a> /
    <span>#<?= (int)$ticket['id'] ?></span>
  </div>

  <?php if (!empty($_SESSION['success'])): ?><div class="alert success"><?= h($_SESSION['success']) ?></div><?php unset($_SESSION['success']); endif; ?>
  <?php if (!empty($_SESSION['error'])):   ?><div class="alert error"><?= h($_SESSION['error'])   ?></div><?php unset($_SESSION['error']);   endif; ?>

  <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap">
    <div>
      <strong>#<?= (int)$ticket['id'] ?> — <?= h($ticket['title']) ?></strong>
      <div class="muted">Utworzono: <?= h($ticket['created_at']) ?> • Ostatnia zmiana: <?= h($ticket['updated_at']) ?></div>
    </div>
    <div class="inline" style="gap:8px;align-items:center">
      <span id="statusChip" class="chip" style="--chip: <?= h($ticket['status_color'] ?: '#e2e8f0') ?>">
        <?= h($ticket['status_name'] ?? '—') ?>
      </span>
      <a class="btn btn-light" href="<?= ROOT_URL ?>modules/cmms/zgloszenia/edit.php?id=<?= (int)$ticket['id'] ?>">Edytuj</a>
      <!-- zamiast otwierać modal: scroll do karty statusu -->
      <button id="scrollToStatus" class="btn btn-secondary">Zmień status</button>
    </div>
  </div>

  <div class="card-content">
    <dl class="def-grid">
      <dt>Priorytet</dt>
      <dd><?= h($ticket['priority']) ?></dd>

      <dt>Typ / Podtyp</dt>
      <dd><?= h(trim(($ticket['type_name'] ?? '') . ' / ' . ($ticket['subtype_name'] ?? ''), ' /')) ?: '—' ?></dd>

      <dt>Grupa odpowiedzialna</dt>
      <dd>
        <?php if (!empty($ticket['group_label'])): ?>
          <?= h($ticket['group_label']) ?>
        <?php else: ?>
          <?php if (defined('CMMS_DEFAULT_GROUP_ID') && (int)CMMS_DEFAULT_GROUP_ID > 0): ?>
            <span class="muted">Domyślna:</span> <?= h(cmms_group_label($pdo, (int)CMMS_DEFAULT_GROUP_ID)) ?>
          <?php else: ?>
            —
          <?php endif; ?>
        <?php endif; ?>
      </dd>

      <dt>Zgłaszający</dt>
      <dd><?= h($ticket['reporter_name'] ?? '—') ?></dd>

      <dt>Przypisany</dt>
      <dd id="ticket-assignee"><?= $ticket['assignee_name'] ? h($ticket['assignee_name']) : '<span class="muted">—</span>' ?></dd>

      <hr>

      <dt>Zasób</dt>
      <dd>
        <?= $ticket['struktura_name'] ? h($ticket['struktura_name']) : '—' ?>
        <?php if ($path): ?><div class="muted" style="font-size:12px"><?= h($path) ?></div><?php endif; ?>
      </dd>

      <dt>Opis</dt>
      <dd style="white-space:pre-wrap"><?= nl2br(h($ticket['description'] ?? '')) ?></dd>
    </dl>
  </div>

  <!-- Kto pracuje -->
  <div class="card" id="wl-card">
    <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;gap:8px">
      <strong>Aktywność przy zgłoszeniu</strong>
      <small class="muted" id="wl-last-refresh">—</small>
    </div>
    <div class="card-content">
      <div class="wl-grid">
        <section>
          <h4>Teraz pracują</h4>
          <div id="wl-active" class="wl-active"></div>
        </section>
        <section>
          <h4>Sumy czasu (użytkownicy)</h4>
          <div id="wl-totals" class="wl-totals"></div>
        </section>
      </div>

      <h4 style="margin-top:14px">Ostatnie wejścia/wyjścia</h4>
      <div class="table-responsive">
        <table class="table wl-sessions">
          <thead>
            <tr><th>Użytkownik</th><th>Start</th><th>Koniec</th><th>Czas</th></tr>
          </thead>
          <tbody id="wl-sessions"></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- historia zmian -->
  <div class="card-header"><strong>Historia statusów</strong></div>
  <div class="card-content table-responsive">
    <table class="table">
      <thead>
        <tr>
          <th>Data</th><th>Z</th><th>Na</th><th>Kto</th><th>Komentarz</th><th>Powód</th><th>Czas w statusie</th>
        </tr>
      </thead>
      <tbody id="historyTbody">
        <?php if (!$history): ?>
          <tr><td colspan="7" class="muted">Brak historii.</td></tr>
        <?php else: foreach ($history as $i => $h): ?>
          <tr>
            <td><?= h($h['changed_at']) ?></td>
            <td><?= h($h['from_name'] ?? '—') ?></td>
            <td><span class="chip" style="--chip: <?= h($h['to_color'] ?: '#e2e8f0') ?>"><?= h($h['to_name'] ?? '—') ?></span></td>
            <td><?= h($h['user_name'] ?? '—') ?></td>
            <td><?= h($h['comment'] ?? '') ?></td>
            <td><?= h($h['reason_code'] ?? '') ?></td>
            <?php if ($i === 0): ?>
              <td id="liveDuration" data-live-since="<?= h($h['changed_at']) ?>"></td>
            <?php else: ?>
              <?php
                $start = new DateTimeImmutable($h['changed_at']);
                $end   = ($i === 0) ? new DateTimeImmutable('now') : new DateTimeImmutable($history[$i-1]['changed_at']);
                $sec   = max(0, $end->getTimestamp() - $start->getTimestamp());
              ?>
              <td><?= hms((int)$sec) ?></td>
            <?php endif; ?>
          </tr>
        <?php endforeach; endif; ?>
      </tbody>
    </table>
  </div>

  <!-- Załączniki -->
  <div class="card">
    <div class="card-header"><strong><?= __('cmms.tickets.attachments','Załączniki') ?></strong></div>
    <div class="card-content">
      <?php if (!empty($files)): ?>
        <div class="gallery">
          <?php foreach ($files as $f):
            $ym      = date('Y/m', strtotime($f['created_at'] ?? 'now'));
            $dirUrl  = $uploadsBase . $ym . '/' . (int)$ticket['id'] . '/';
            $thumbUrl= $dirUrl . ($f['thumb_name'] ?? $f['stored_name']);
            $fullUrl = $dirUrl . $f['stored_name'];
          ?>
            <figure class="gallery__item">
              <a href="<?= h($fullUrl) ?>" target="_blank" rel="noopener">
                <img src="<?= h($thumbUrl) ?>" alt="<?= h($f['original_name'] ?? '') ?>">
              </a>
              <figcaption class="gallery__caption">
                <span class="truncate"><?= h($f['original_name'] ?? '') ?></span>
                <?php if ($canEdit): ?>
                  <a class="btn btn-sm btn-danger"
                     href="delete_file.php?id=<?= (int)$f['id'] ?>&ticket_id=<?= (int)$ticket['id'] ?>&csrf=<?= h(csrf_token()) ?>"
                     onclick="return confirm('Usunąć załącznik?')">Usuń</a>
                <?php endif; ?>
              </figcaption>
            </figure>
          <?php endforeach; ?>
        </div>
      <?php else: ?>
        <p class="muted">Brak załączników.</p>
      <?php endif; ?>

      <?php if ($canEdit): ?>
        <hr>
        <form method="post" action="upload.php?ticket_id=<?= (int)$ticket['id'] ?>" enctype="multipart/form-data" class="upload-form">
          <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
          <input type="hidden" name="ticket_id" value="<?= (int)$ticket['id'] ?>">

          <label for="photos">Dodaj zdjęcia (z aparatu lub galerii)</label>
          <input
            id="photos"
            name="photos[]"
            type="file"
            accept="image/*"
            capture="environment"
            multiple
            required
          >
          <small class="muted">Max ~12&nbsp;MB/plik. HEIC konwertujemy do JPEG (jeśli dostępny ImageMagick).</small>

          <div class="actions-row" style="margin-top:8px">
            <button class="btn btn-primary" type="submit">Wyślij</button>
          </div>
        </form>
      <?php endif; ?>
    </div>
  </div>

  <!-- ZAŁĄCZNIKI ZASOBU -->
  <div class="card">
  <?php
    requirePermission(['cmms.files.view','cmms.*','admin.*']);
    $entityType = 'structure';
    $entityId   = isset($ticket['struktura_id']) ? (int)$ticket['struktura_id'] : 0;

    if ($entityId > 0) {
      $FILES_GALLERY_LIMIT = 24;
      include ROOT_PATH.'modules/files/gallery_grouped.php';
    } else {
      echo '<div class="card"><div class="card-header"><strong>Załączniki zasobu</strong></div><div class="card-content"><p class="muted">Brak powiązanego zasobu dla tego zgłoszenia.</p></div></div>';
    }
  ?>
  </div>

  <!-- LIGHT: karta zmiany statusu (zamiast modala) -->
  <div class="card" id="statusCard">
    <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;gap:8px">
      <div>
        <strong>Zmień status</strong>
        <span class="muted" style="margin-left:8px">
          Aktualny:
          <span class="chip" style="--chip: <?= h($ticket['status_color'] ?: '#e2e8f0') ?>"><?= h($ticket['status_name'] ?? '—') ?></span>
          <?php if ($workflowId): ?>
            <span class="badge" title="Workflow ID">WF: #<?= (int)$workflowId ?></span>
          <?php else: ?>
            <span class="badge" title="Global transitions">Global</span>
          <?php endif; ?>
        </span>
      </div>
    </div>

    <div class="card-content">
      <?php
        $ticketId = (int)$ticket['id'];
        $canWork  = function_exists('checkAccess') ? checkAccess(['cmms.tickets.edit','cmms.worklog.start','cmms.worklog.stop','cmms.*','admin.*']) : false;
      ?>
      <?php if ($canWork): ?>
        <section class="card worklog-card" data-ticket="<?= (int)$ticketId ?>" id="worklog-panel">
          <h4>Praca nad zgłoszeniem</h4>
          <div class="actions-row">
            <button type="submit"
				class="btn btn-primary"
				form="stForm"
				formaction="<?= $ZBASE ?>actions/worklog_start.php"
				formmethod="post"
				formnovalidate
				data-wl="start">▶️ Start pracy</button>

            <button type="submit"
				class="btn"
				form="stForm"
				formaction="<?= $ZBASE ?>actions/worklog_stop.php"
				formmethod="post"
				formnovalidate
				data-wl="stop">⏹ Stop pracy</button>

            <div class="spacer"></div>
            <div class="who-now" id="who-now">Ładowanie…</div>
          </div>
          <p class="muted" id="wl-hint" style="margin-top:6px"></p>
        </section>
      <?php endif; ?>

      <!-- JEDYNY formularz zmiany statusu -->
	  
      <form id="stForm" method="post" action="<?= $ZBASE ?>actions/change_status.php" novalidate>
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="id" value="<?= (int)$ticket['id'] ?>">
        <input type="hidden" name="ticket_id" value="<?= (int)$ticket['id'] ?>">
        <input type="hidden" name="from_status_id" value="<?= (int)$ticket['status_id'] ?>">

        <!-- AJAX hint -->
        <input type="hidden" name="ajax" value="1">

        <input type="hidden" name="action" value="change_status">
        <input type="hidden" name="to_status_id" id="to_status_id">

        <fieldset class="radio-list">
          <?php if (!$transitions): ?>
            <div class="muted">Brak dostępnych przejść.</div>
          <?php else: foreach ($transitions as $i => $tr):
            $toId   = (int)$tr['to_status_id'];
            $toName = $toMap[$toId]['name']  ?? ('#'.$toId);
            $toCol  = $toMap[$toId]['color'] ?? '#e2e8f0';
          ?>
            <label class="inline">
              <input
                  type="radio"
                  name="transition_id"
                  value="<?= (int)$tr['id'] ?>"
                  data-to-status-id="<?= (int)$tr['to_status_id'] ?>"
                  <?= $i===0 ? 'checked' : '' ?>
                  data-req-comment="<?= (int)$tr['requires_comment'] ?>"
                  data-req-reason="<?= (int)$tr['requires_reason'] ?>"
                  data-req-assignee="<?= (int)$tr['requires_assignee'] ?>"
                  data-reason-type="<?= h((string)($tr['reason_type'] ?? '')) ?>"
                >
              <span class="chip" style="--chip: <?= h($toCol) ?>"><?= h($toName) ?></span>
              <?php if (!empty($tr['requires_comment'])):  ?><span class="badge">komentarz</span><?php endif; ?>
              <?php if (!empty($tr['requires_reason'])):   ?><span class="badge">powód</span><?php endif; ?>
              <?php if (!empty($tr['requires_assignee'])): ?><span class="badge">assignee</span><?php endif; ?>
              <?php if (!empty($tr['set_resolved_at'])):   ?><span class="badge" title="Oznaczy rozwiązane">resolved</span><?php endif; ?>
              <?php if (!empty($tr['set_closed_at'])):     ?><span class="badge" title="Oznaczy zamknięte">closed</span><?php endif; ?>
              <?php if (!empty($tr['pause_sla'])):         ?><span class="badge" title="Wstrzyma SLA">pause SLA</span><?php endif; ?>
              <?php if (!empty($tr['resume_sla'])):        ?><span class="badge" title="Wznawia SLA">resume SLA</span><?php endif; ?>
            </label>
          <?php endforeach; endif; ?>
        </fieldset>

        <div class="field-pair">
          <label for="stComment">Komentarz</label>
          <textarea id="stComment" name="comment" class="input" rows="4" placeholder="Opcjonalnie: dopisz szczegóły…"></textarea>
        </div>

        <div class="field-pair">
          <label for="stReason" id="stReasonLabel">Powód</label>
          <input id="stReason" name="reason_code" class="input" list="stReasonList" placeholder="np. oczekiwanie na części">
          <datalist id="stReasonList"></datalist>
          <div id="reasonChips" class="suggest-chips hidden"></div>
        </div>

        <?php if ($canAssignUser): ?>
        <div id="assigneeWrap" class="hidden field-pair">
          <label for="stAssignee">Przypisany (jeśli wymagany)</label>
          <select id="stAssignee" name="assignee_id" class="input" style="width:100%">
            <?php if (!empty($ticket['assignee_id'])): ?>
              <option value="<?= (int)$ticket['assignee_id'] ?>" selected>
                <?= h($ticket['assignee_name'] ?? ('#'.(int)$ticket['assignee_id'])) ?>
              </option>
            <?php endif; ?>
          </select>
          <small class="muted" id="assigneeHint">
            <?= $ticket['assignee_id'] ? h('Aktualnie: '.($ticket['assignee_name'] ?? '').' (#'.(int)$ticket['assignee_id'].')') : '' ?>
          </small>
        </div>
        <?php endif; ?>

        <div class="form-actions">
          <button type="submit" class="btn btn-primary" id="stSubmitBtn">Zapisz</button>
          <button type="button" class="btn btn-light" id="stCancelBtn">Anuluj</button>
        </div>
      </form>

      <div id="stError" class="status danger hidden" role="status" aria-live="polite" aria-atomic="true" tabindex="-1"></div>
    </div>
  </div>
</main>

<style>
  .gallery { display:grid; grid-template-columns: repeat(auto-fill, minmax(160px,1fr)); gap:12px; }
  .gallery__item { border:1px solid var(--color-border,#e5e7eb); border-radius:10px; overflow:hidden; background:#fff; }
  .gallery__item img { display:block; width:100%; height:140px; object-fit:cover; }
  .gallery__caption { display:flex; align-items:center; justify-content:space-between; gap:8px; padding:8px; font-size:12px; }
  .truncate { overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width: 70%; }
  .btn.btn-sm { padding:4px 8px; font-size:12px; }
  .btn-danger { background:#ef4444; color:#fff; }
  .upload-form input[type="file"] { display:block; margin-top:6px; }
  .hidden { display:none; }
  .invalid { border-color:#ef4444 !important; box-shadow: 0 0 0 2px rgba(239,68,68,.15); }

  .wl-grid { display:grid; grid-template-columns: 1fr 1fr; gap:16px; }
  .wl-active { display:flex; flex-wrap:wrap; gap:8px; }
  .wl-chip {
    display:inline-flex; align-items:center; gap:8px;
    padding:6px 10px; border:1px solid #e5e7eb; border-radius:999px; background:#fff;
    box-shadow: 0 1px 0 rgba(0,0,0,.03);
  }
  .wl-chip .name { font-weight:600; }
  .wl-chip .timer { font-variant-numeric: tabular-nums; color:#374151; }
  .wl-totals .row { display:flex; justify-content:space-between; padding:4px 0; border-bottom:1px dashed #eee; }
  .wl-totals .row:last-child { border-bottom:0; }
  .wl-bar { height:6px; border-radius:999px; background:#e5e7eb; overflow:hidden; margin-top:4px; }
  .wl-bar > span { display:block; height:100%; background:#0ea5e9; width:0; }
  @media (max-width: 920px){ .wl-grid { grid-template-columns: 1fr; } }
  .suggest-chips { display:flex; flex-wrap:wrap; gap:6px; margin-top:6px; }
  .suggest-chip { border:1px solid #e5e7eb; background:#f8fafc; padding:4px 10px; border-radius:999px; cursor:pointer; font-size:12px; }
  .suggest-chip:hover { background:#eef2f7; }

  /* drobne ułatwienia mobilne */
  @media (max-width: 640px) {
    .def-grid dt, .def-grid dd { display:block; }
    .card-header .inline { width:100%; justify-content:flex-start; gap:6px; }
    .table-responsive { overflow-x:auto; }
  }
</style>

<script>
/* żywy licznik czasu w ostatnim statusie */
(() => {
  const live = document.getElementById('liveDuration');
  if (live && live.dataset.liveSince) {
    const since = new Date(live.dataset.liveSince).getTime();
    const fmt = s => {
      const h = Math.floor(s/3600), m = Math.floor((s%3600)/60), ss = s%60;
      return [h,m,ss].map(n => String(n).padStart(2,'0')).join(':');
    };
    const tick = () => {
      const secs = Math.max(0, Math.floor((Date.now()-since)/1000));
      live.textContent = fmt(secs);
    };
    tick(); setInterval(tick, 1000);
  }
})();
</script>

<script>
;(function () {
	const ZBASE = '<?= $ZBASE ?>';
	const TICKET_ID = <?= (int)$ticket['id'] ?>;
	
  const errEl = document.getElementById('stError');
  const ME = <?= (int)(currentUser()['id'] ?? 0) ?>;

  const radioSelector = 'input[name="transition_id"]';
  function getSelectedRadio(){ return document.querySelector(radioSelector + ':checked'); }

  function showErr(msg){
    errEl.textContent = msg || '';
    const visible = !!msg;
    errEl.classList.toggle('hidden', !visible);
    errEl.setAttribute('aria-hidden', String(!visible));
    if (visible) { try { errEl.focus(); } catch(e){} }
  }

  // Skrol do karty statusu
  const scrollBtn = document.getElementById('scrollToStatus');
  if (scrollBtn) {
    scrollBtn.addEventListener('click', () => {
      const card = document.getElementById('statusCard');
      if (card) { card.scrollIntoView({behavior:'smooth', block:'start'}); }
      // przy okazji zsynchronizuj przyciski i assignee
      window.syncWorklogButtons && window.syncWorklogButtons();
      <?php if ($canAssignUser): ?> loadEligibleAssignees(); <?php endif; ?>
      applyTransitionUI(getSelectedRadio());
    });
  }

  // —— pola formularza
  const assWrap   = document.getElementById('assigneeWrap');
  const assSel    = document.getElementById('stAssignee');
  const reasonEl  = document.getElementById('stReason');
  const reasonLb  = document.getElementById('stReasonLabel');
  const commEl    = document.getElementById('stComment');
  const reasonList  = document.getElementById('stReasonList');
  const reasonChips = document.getElementById('reasonChips');
  const toStatusHidden = document.getElementById('to_status_id');
  const submitBtn = document.getElementById('stSubmitBtn');

  // —— Select2 (LIGHT: dropdownParent = body)
  function initAssigneeSelect2(){
    if (!window.jQuery || !window.$ || !assSel) return;
    const $el = $('#stAssignee');
    if ($el.data('select2')) return;
    $el.select2({
      placeholder: "Wybierz użytkownika",
      allowClear: true,
      width: '100%',
      dropdownParent: $(document.body),
      language: { inputTooShort: ()=>'Wpisz min. 1 znak', noResults: ()=>'Brak wyników', searching: ()=>'Szukam…' }
    });
  }
   const eligibleUrl = `${ZBASE}ajax/eligible_users.php?type_id=<?= (int)($ticket['type_id'] ?? 0) ?>&subtype_id=<?= (int)($ticket['subtype_id'] ?? 0) ?>&struktura_id=<?= (int)($ticket['struktura_id'] ?? 0) ?>`;
   
  function rebuildAssigneeSelect(json, preserveValue, autoPickMe) {
    if (!assSel) return;
    const current = preserveValue ?? assSel.value ?? '';
    assSel.innerHTML = '';

    const opt0 = document.createElement('option');
    opt0.value = '';
    opt0.textContent = '— nie przydzielaj —';
    assSel.appendChild(opt0);

    const users = (json && Array.isArray(json.users)) ? json.users : [];
    const byGroup = {};
    users.forEach(u => { const gl = u.group_label || 'Grupa'; (byGroup[gl] ||= []).push(u); });

    let meIsPresent = false;

    Object.keys(byGroup).forEach(label => {
      const og = document.createElement('optgroup'); og.label = label;
      byGroup[label].forEach(u => {
        const o = document.createElement('option');
        o.value = String(u.id);
        o.textContent = u.label || ('ID ' + u.id);
        if (String(u.id) === String(ME)) meIsPresent = true;
        if (String(current) === String(u.id)) o.selected = true;
        og.appendChild(o);
      });
      assSel.appendChild(og);
    });

    if (autoPickMe && !assSel.value && meIsPresent) {
      assSel.value = String(ME);
    }

    if (window.jQuery && window.$) {
      const $el = $('#stAssignee');
      if ($el.data('select2')) { $el.trigger('change.select2'); } else { initAssigneeSelect2(); }
    }
  }

  function loadEligibleAssignees(autoPickMe = false) {
    <?php if (!$canAssignUser): ?> return; <?php endif; ?>
    fetch(eligibleUrl, { credentials:'same-origin', headers:{ 'Accept':'application/json' } })
      .then(r => r.ok ? r.json() : Promise.reject(new Error('HTTP ' + r.status)))
      .then(json => rebuildAssigneeSelect(json, assSel ? assSel.value : '', autoPickMe))
      .catch(() => rebuildAssigneeSelect({ users: [] }, assSel ? assSel.value : '', false));
  }

  // —— synchronizacja hidden to_status_id z WYBRANEGO radio
  function syncHiddenToStatus(){
    const r = getSelectedRadio();
    const v = r?.dataset?.toStatusId || '';
    if (toStatusHidden) toStatusHidden.value = v;
  }

  // —— UI zależny od przejścia + required
  function applyTransitionUI(radio){
    if (!radio) return;
    const needComment  = radio.dataset.reqComment  === '1';
    const needReason   = radio.dataset.reqReason   === '1';
    const needAssignee = radio.dataset.reqAssignee === '1';
    const reasonType   = (radio.dataset.reasonType || '').trim();

    [commEl, reasonEl, assSel].forEach(el => el && el.classList.remove('invalid'));

    if (reasonType) {
      reasonLb.textContent = 'Powód (' + reasonType + ')';
      reasonEl.placeholder = 'Wybierz/wpisz powód (' + reasonType + ')';
    } else {
      reasonLb.textContent = 'Powód';
      reasonEl.placeholder = 'np. oczekiwanie na części';
    }

    <?php if ($canAssignUser): ?>
    assWrap && assWrap.classList.toggle('hidden', !needAssignee);
    if (needAssignee) {
      initAssigneeSelect2();
      loadEligibleAssignees(!assSel || !assSel.value);
    }
    <?php endif; ?>

    renderReasonSuggestions(reasonType || (needReason ? 'waiting' : 'generic'));
    syncHiddenToStatus();
    showErr('');
  }

  // —— recent reasons
  const RECENT_PREFIX = 'cmms.reason.';
  const DEFAULTS = { waiting: ['brak części','kontrahent','okno technologiczne','brak dostępu','czekamy na decyzję','przegląd zewnętrzny'] };
  const storeKey = t => RECENT_PREFIX + (t || 'generic');
  function recentLoad(t){ try { const raw = localStorage.getItem(storeKey(t)); const a = raw?JSON.parse(raw):[]; return Array.isArray(a)?a:[]; } catch { return []; } }
  function recentSave(t,val){
    val = (val||'').trim(); if(!val) return;
    let arr = recentLoad(t).filter(v => v.toLowerCase() !== val.toLowerCase());
    arr.unshift(val); if (arr.length>10) arr = arr.slice(0,10);
    try { localStorage.setItem(storeKey(t), JSON.stringify(arr)); } catch {}
  }
  function renderReasonSuggestions(type){
    const t = (type || 'generic');
    let arr = recentLoad(t);
    if (!arr.length && DEFAULTS[t]) arr = DEFAULTS[t];

    if (reasonList){
      reasonList.innerHTML = '';
      arr.forEach(v => { const opt = document.createElement('option'); opt.value = v; reasonList.appendChild(opt); });
    }
    if (reasonChips){
      reasonChips.innerHTML = '';
      if (arr.length){
        reasonChips.classList.remove('hidden');
        arr.slice(0,6).forEach(v=>{
          const b=document.createElement('button'); b.type='button'; b.className='suggest-chip'; b.textContent=v;
          b.addEventListener('click', ()=>{ reasonEl.value=v; reasonEl.focus(); });
          reasonChips.appendChild(b);
        });
      } else reasonChips.classList.add('hidden');
    }
  }

  // —— nasłuchy
  const radios = Array.from(document.querySelectorAll(radioSelector));
  radios.forEach(r => r.addEventListener('change', () => applyTransitionUI(getSelectedRadio())));
  applyTransitionUI(getSelectedRadio());

  // ====== pomocnicze: postJson + heurystyka sukcesu (JSON lub redirect/HTML)
  async function postJson(url, body) {
    const res = await fetch(url, {
      method: 'POST',
      body,
      credentials: 'same-origin',
      headers: { 'Accept': 'application/json' }
    });
    let json = null;
    try { json = await res.json(); } catch {}
    return { res, json };
  }
  function looksLikeSuccess(res, json) {
    if (json && json.ok === true) return true;
    const ct = (res.headers.get('content-type') || '').toLowerCase();
    if (res.redirected) return true;
    if (res.ok && ct.includes('text/html')) return true;
    return false;
  }

  // —— submit statusu AJAX-em
  const form = document.getElementById('stForm');
  if (form){
    form.addEventListener('submit', async function(e){
      e.preventDefault();
      const r = getSelectedRadio();
      if (!r){ showErr('Wybierz docelowy status.'); return; }

      const needComment  = r.dataset.reqComment  === '1';
      const needReason   = r.dataset.reqReason   === '1';

      if (needComment && (!commEl || !commEl.value.trim())){
        showErr('Komentarz jest wymagany dla tego przejścia.');
        commEl?.classList.add('invalid'); commEl?.focus();
        return;
      }
      if (needReason && (!reasonEl || !reasonEl.value.trim())){
        showErr('Powód jest wymagany dla tego przejścia.');
        reasonEl?.classList.add('invalid'); reasonEl?.focus();
        return;
      }

      syncHiddenToStatus();
      const rType = (r.dataset.reasonType || (needReason ? 'waiting' : 'generic'));
      if (needReason && reasonEl && reasonEl.value.trim()) {
        recentSave(rType, reasonEl.value.trim());
      }

      const fd = new FormData(form);
      submitBtn && (submitBtn.disabled = true);
      try {
        let { res, json } = await postJson(form.action, fd);

        if (res.status === 404) {
          const base = window.location.href;
          const tried = new URL(form.action, base).toString();
          const candidates = [
            'actions/change_status.php',
            '../zgloszenia/actions/change_status.php',
            'change_status.php'
          ].map(u => new URL(u, base).toString());

          for (const url of candidates) {
            if (url === tried) continue;
            ({ res, json } = await postJson(url, fd));
            if (looksLikeSuccess(res, json)) break;
          }
        }

        if (!looksLikeSuccess(res, json)) {
          const msg = (json && json.error) ? json.error : ('Błąd ('+res.status+')');
          showErr(msg);

          if (/komentarz/i.test(msg)) { commEl?.classList.add('invalid'); commEl?.focus(); }
          else if (/powód|powod/i.test(msg)) { reasonEl?.classList.add('invalid'); reasonEl?.focus(); }
          else if (/przypisan/i.test(msg)) {
            <?php if ($canAssignUser): ?> assWrap && assWrap.classList.remove('hidden'); assSel?.classList.add('invalid'); assSel?.focus(); <?php endif; ?>
          }
          return;
        }

        window.location.reload();
      } catch (err) {
        showErr('Błąd połączenia. Spróbuj ponownie.');
      } finally {
        submitBtn && (submitBtn.disabled = false);
      }
    });
  }

  // „Anuluj” w wersji light — po prostu przewiń na górę
  const cancelBtn = document.getElementById('stCancelBtn');
  if (cancelBtn) {
    cancelBtn.addEventListener('click', () => {
      window.scrollTo({top: 0, behavior: 'smooth'});
    });
  }
})();
</script>

<script>
/* Worklog panel: who_now + sync + start/stop (bez modala — działa identycznie) */
(function(){
	const ZBASE = '<?= $ZBASE ?>';
	const TICKET_ID = <?= (int)$ticket['id'] ?>;
	
  const form   = document.getElementById('stForm');
  const whoNow = document.getElementById('who-now');
  const wlHint = document.getElementById('wl-hint');

  const startBtn = document.querySelector('button[data-wl="start"]');
  const stopBtn  = document.querySelector('button[data-wl="stop"]');

  let wlState = null;

  function toast(msg){ try { console.log(msg); } catch(e){} }

  async function refreshWhoNow(){
    if (!whoNow) return;
    try {
       const res = await fetch(`${ZBASE}ajax/who_now.php?ticket_id=${TICKET_ID}`, { credentials: 'same-origin' });
      whoNow.innerHTML = await res.text();
    } catch { whoNow.textContent = '—'; }
  }

  async function syncWorklogButtons(){
    try {
		const res = await fetch(`${ZBASE}ajax/worklog_state.php?ticket_id=${TICKET_ID}`, { credentials:'same-origin' });
      const j = await res.json();
      if (!j.ok) throw new Error(j.error||'Błąd');
      wlState = j;

      if (j.active_on_this) {
        startBtn && (startBtn.disabled = true);
        stopBtn  && (stopBtn.disabled  = false);
        wlHint && (wlHint.textContent = 'Pracujesz nad tym zgłoszeniem od ' + (j.active_since||''));
      } else if (j.active_any) {
        startBtn && (startBtn.disabled = true);
        stopBtn  && (stopBtn.disabled  = true);
        wlHint && (wlHint.textContent = 'Masz otwarty wpis pracy w zgłoszeniu #' + j.active_ticket_id + '. Zatrzymaj go, aby rozpocząć tutaj.');
      } else {
        startBtn && (startBtn.disabled = false);
        stopBtn  && (stopBtn.disabled  = true);
        wlHint && (wlHint.textContent = '');
      }
    } catch (e) {
      startBtn && (startBtn.disabled = true);
      wlHint && (wlHint.textContent = 'Nie udało się sprawdzić stanu pracy. Odśwież stronę.');
    }
  }

  window.syncWorklogButtons = syncWorklogButtons;

  async function submitWorklog(button){
    if (!form) return;

    if (button.dataset.wl === 'start' && wlState && wlState.active_any && !wlState.active_on_this) {
      alert('Masz już otwarty wpis pracy w zgłoszeniu #' + wlState.active_ticket_id + '. Najpierw go zatrzymaj.');
      return;
    }

    const fd = new FormData(form);
    if (!fd.get('ticket_id')) fd.set('ticket_id', '<?= (int)$ticket['id'] ?>');
    if (!fd.get('csrf'))      fd.set('csrf', form.querySelector('input[name="csrf"]').value);

    button.disabled = true;
    try {
      const res  = await fetch(button.formAction, {
        method: 'POST',
        body: fd,
        credentials: 'same-origin',
        headers: { 'Accept': 'application/json' }
      });
      const json = await res.json();
      if (!json.ok) throw new Error(json.error || 'Błąd');

      toast(button.dataset.wl === 'start' ? 'Rozpoczęto pracę.' : 'Zatrzymano pracę.');

      await syncWorklogButtons();
      await refreshWhoNow();
      if (window.refreshWorklogSummary) window.refreshWorklogSummary();

    } catch (e) {
      alert(e.message || 'Błąd połączenia');
    } finally {
      button.disabled = false;
    }
  }

  document.addEventListener('click', (e) => {
    const btn = e.target.closest('button[data-wl]');
    if (!btn || !btn.formAction) return;
    e.preventDefault();
    submitWorklog(btn);
  });

  syncWorklogButtons();
  refreshWhoNow();
})();
</script>

<script>
(function(){
  const TICKET_ID = <?= (int)$ticket['id'] ?>;
  const url = `${ZBASE}ajax/worklog_summary.php?ticket_id=${TICKET_ID}`;


  const $active  = document.getElementById('wl-active');
  const $totals  = document.getElementById('wl-totals');
  const $sessTbd = document.getElementById('wl-sessions');
  const $stamp   = document.getElementById('wl-last-refresh');

  const fmt = s => {
    s = Math.max(0, s|0);
    const h = Math.floor(s/3600), m = Math.floor((s%3600)/60), ss = s%60;
    return [h,m,ss].map(n=>String(n).padStart(2,'0')).join(':');
  };

  let ticking = [];
  function stopTicks(){ ticking.forEach(t=>clearInterval(t._i)); ticking = []; }
  function startTicks(){
    ticking.forEach(t=>{
      t._i = setInterval(()=>{
        const sec = t.baseSeconds + Math.floor((Date.now()-t.startedAt)/1000);
        t.el.textContent = fmt(sec);
      }, 1000);
    });
  }

  function renderActive(arr){
    stopTicks();
    $active.innerHTML = '';
    if (!arr.length){ $active.innerHTML = '<span class="muted">Nikt aktualnie nie pracuje.</span>'; return; }
    arr.forEach(a=>{
      const chip = document.createElement('div'); chip.className = 'wl-chip';
      chip.innerHTML = `<span class="name">${a.label}</span> <span class="timer">...</span>`;
      const timerEl = chip.querySelector('.timer');
      const base = parseInt(a.seconds||0,10);
      timerEl.textContent = fmt(base);
      ticking.push({el: timerEl, startedAt: Date.now(), baseSeconds: base});
      $active.appendChild(chip);
    });
    startTicks();
  }

  function renderTotals(arr, totalAll){
    $totals.innerHTML = '';
    if (!arr.length){ $totals.innerHTML = '<span class="muted">Brak danych.</span>'; return; }
    const max = totalAll || arr[0].seconds || 0;
    arr.forEach(t=>{
      const row = document.createElement('div'); row.className = 'row';
      row.innerHTML = `
        <div style="min-width:0;flex:1">
          <div style="display:flex;justify-content:space-between;gap:8px">
            <span class="name" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${t.label}</span>
            <span class="timer">${fmt(t.seconds)}</span>
          </div>
          <div class="wl-bar"><span style="width:${max ? (100*t.seconds/max).toFixed(1) : 0}%"></span></div>
        </div>
      `;
      $totals.appendChild(row);
    });
  }

  function renderSessions(arr){
    $sessTbd.innerHTML = '';
    if (!arr.length){ $sessTbd.innerHTML = '<tr><td colspan="4" class="muted">Brak sesji.</td></tr>'; return; }
    arr.forEach(s=>{
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td>${s.label}</td>
        <td>${s.start_at}</td>
        <td>${s.end_at ? s.end_at : '<span class="chip" style="--chip:#0ea5e9">w toku</span>'}</td>
        <td>${fmt(s.seconds)}</td>
      `;
      $sessTbd.appendChild(tr);
    });
  }

  async function fetchJsonSafe(u){
    const res = await fetch(u, {credentials:'same-origin'});
    const ct = (res.headers.get('content-type')||'').toLowerCase();
    const text = await res.text();

    // próba JSON
    try {
      const json = JSON.parse(text);
      return { ok: true, json, status: res.status };
    } catch {
      // nie-JSON → HTML? login? błąd PHP?
      return { ok: false, status: res.status, text, contentType: ct };
    }
  }

  async function refresh(){
    const r = await fetchJsonSafe(url);

    if (!r.ok) {
      console.error('[worklog_summary] HTML/ERR payload:', r);
      const looksLikeLogin = r.text && /<form[^>]+login|logowanie|hasło/i.test(r.text);
      const looksLikeError = r.text && /Fatal error|Warning|Notice|Exception/i.test(r.text);

      if (looksLikeLogin) {
        $stamp.textContent = 'Brak uprawnień / zaloguj ponownie';
      } else if (looksLikeError) {
        $stamp.textContent = 'Błąd serwera (szczegóły w konsoli)';
      } else {
        $stamp.textContent = 'Niepoprawna odpowiedź (nie-JSON)';
      }
      // Nie rozjeżdżaj widoku – pokaż info
      $active.innerHTML  = '<span class="muted">—</span>';
      $totals.innerHTML  = '<span class="muted">—</span>';
      $sessTbd.innerHTML = '<tr><td colspan="4" class="muted">—</td></tr>';
      return;
    }

    const j = r.json;
    if (!j || j.ok !== true) {
      console.error('[worklog_summary] backend error:', j);
      $stamp.textContent = j && j.error ? j.error : 'Błąd danych';
      return;
    }

    renderActive(j.active||[]);
    renderTotals(j.totals||[], j.total_seconds||0);
    renderSessions(j.sessions||[]);
    $stamp.textContent = 'Odświeżono: ' + new Date().toLocaleTimeString();
  }

  refresh();
  setInterval(refresh, 15000);

  window.refreshWorklogSummary = refresh;
})();
</script>


<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
