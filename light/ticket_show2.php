<?php
// /light/ticket_show.php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';
require_once ROOT_PATH.'api/cmms/status_change.php';

requireLogin();
requirePermission(['cmms.tickets.view','cmms.*','admin.*']);

/** @var PDO $pdo */
$pdo = pdo();
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

/* ---------- helpers ---------- */
if (!function_exists('h')) {
  function h(?string $s): string { return htmlspecialchars((string)$s, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }
}
if (!function_exists('currentUserId')) {
  function currentUserId(): int {
    if (function_exists('currentUser')) { $u=currentUser(); if (is_array($u) && isset($u['id'])) return (int)$u['id']; }
    return isset($_SESSION['user']['id']) ? (int)$_SESSION['user']['id'] : 0;
  }
}
function tableExists(PDO $pdo, string $name): bool {
  $res = $pdo->query("SHOW TABLES LIKE ".$$pdo->quote($name)); // typo fix below
  return (bool)($res && $res->fetch(PDO::FETCH_NUM));
}
function colExists(PDO $pdo, string $table, string $col): bool {
  $res = $pdo->query("SHOW COLUMNS FROM `{$table}` LIKE ".$pdo->quote($col));
  return (bool)($res && $res->fetch(PDO::FETCH_ASSOC));
}
if (!function_exists('logError')) {
  function logError(string $msg): void { error_log('[CMMS/LIGHT] '.$msg); }
}
/* — poprawka literówki w tableExists — */
function tableExists_fix(PDO $pdo, string $name): bool {
  $res = $pdo->query("SHOW TABLES LIKE ".$pdo->quote($name));
  return (bool)($res && $res->fetch(PDO::FETCH_NUM));
}
/* — miękki wrapper na uprawnienia: bez wyrzucania do index.php — */
function mustHave(array $perms, int $ticketId): void {
  if (!function_exists('checkAccess') || !checkAccess($perms)) {
    flash('error','Brak uprawnień do wykonania akcji.');
    safe_redirect("/light/ticket_show.php?id={$ticketId}"); exit;
  }
}
/* — mini debug do error_log — */
function dbg(string $label, $data): void {
  try { error_log('[LIGHT DEBUG] '.$label.': '.(is_scalar($data)?$data:json_encode($data, JSON_UNESCAPED_UNICODE))); } catch(Throwable $e) {}
}

/* ---------- input ---------- */
$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) { flash('error','Brak ID zgłoszenia.'); safe_redirect('/light/index.php'); exit; }

/* ---------- fetch ticket ---------- */
$st = $pdo->prepare("
  SELECT
    t.id, t.title, t.description, t.priority,
    t.status_id, t.type_id, t.subtype_id, t.struktura_id,
    t.group_id, t.reporter_id, t.assignee_id, t.workflow_id,
    t.created_at, t.updated_at,
    s.name AS status_name, s.color AS status_color,
    ty.name AS type_name, stp.name AS subtype_name,
    stru.nazwa AS struktura_name
  FROM cmms_tickets t
  LEFT JOIN cmms_statuses        s   ON s.id   = t.status_id
  LEFT JOIN cmms_ticket_types    ty  ON ty.id  = t.type_id
  LEFT JOIN cmms_ticket_subtypes stp ON stp.id = t.subtype_id
  LEFT JOIN cmms_struktura       stru ON stru.id = t.struktura_id
  WHERE t.id = ?
  LIMIT 1
");
$st->execute([$id]);
$T = $st->fetch(PDO::FETCH_ASSOC);
if (!$T) { flash('error','Nie znaleziono zgłoszenia.'); safe_redirect('/light/index.php'); exit; }

/* ---------- transitions ---------- */
$workflowId = isset($T['workflow_id']) && $T['workflow_id'] !== null
  ? (int)$T['workflow_id']
  : cmms_resolve_workflow_id($pdo, (int)$T['type_id'], $T['subtype_id'] !== null ? (int)$T['subtype_id'] : null);

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
      COALESCE(order_no,0)          AS sort_order
    FROM cmms_workflow_transitions
    WHERE workflow_id = :wf
      AND (from_status_id = :from OR from_status_id IS NULL OR from_status_id = 0)
    ORDER BY order_no, id
  ");
  $q->execute([':wf'=>$workflowId, ':from'=>(int)$T['status_id']]);
  $transitions = $q->fetchAll(PDO::FETCH_ASSOC) ?: [];
} else {
  $q = $pdo->prepare("
    SELECT id, NULL AS workflow_id, from_status_id, to_status_id,
           0 AS requires_comment, 0 AS requires_reason, 0 AS requires_assignee,
           NULL AS reason_type, 0 AS set_resolved_at, 0 AS set_closed_at, 0 AS sort_order
    FROM cmms_status_transitions
    WHERE (from_status_id = :from OR from_status_id IS NULL OR from_status_id = 0)
    ORDER BY id
  ");
  $q->execute([':from'=>(int)$T['status_id']]);
  $transitions = $q->fetchAll(PDO::FETCH_ASSOC) ?: [];
}

/* mapy pomocnicze */
$transById   = [];
$transByToId = [];
$toIds = [];
foreach ($transitions as $tr) {
  $transById[(int)$tr['id']] = $tr;
  $transByToId[(int)$tr['to_status_id']] = $tr;
  $toIds[] = (int)$tr['to_status_id'];
}
$toIds = array_values(array_unique($toIds));

/* nazwy docelowych statusów */
$toMap = [];
if ($toIds) {
  $in  = implode(',', array_fill(0, count($toIds), '?'));
  $qs  = $pdo->prepare("SELECT id, name, color FROM cmms_statuses WHERE id IN ($in)");
  $qs->execute($toIds);
  foreach ($qs->fetchAll(PDO::FETCH_ASSOC) as $row) {
    $toMap[(int)$row['id']] = ['name'=>$row['name'], 'color'=>$row['color']];
  }
}

/* ---------- POST actions ---------- */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // oversize guard
  $cl = (int)($_SERVER['CONTENT_LENGTH'] ?? 0);
  if ($cl > 0 && empty($_POST) && empty($_FILES)) {
    flash('error','Przekroczono limit uploadu (post_max_size / upload_max_filesize).');
    safe_redirect("/light/ticket_show.php?id={$id}"); exit;
  }
  $token = $_POST['csrf'] ?? $_POST['_token'] ?? $_POST['csrf_token'] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? null);
  csrf_verify($token);
  $act = $_POST['action'] ?? '';

  // diagnostyka wejścia
  dbg('POST action', $act);
  dbg('POST raw', $_POST);

  // znajdź przejście po parametrach
  $pickTransition = function () use ($transById, $transByToId) : ?array {
    $tid = (int)($_POST['transition_id'] ?? 0);
    if ($tid && isset($transById[$tid])) return $transById[$tid];
    $to  = (int)($_POST['to_status_id'] ?? $_POST['new_status_id'] ?? 0);
    if ($to && isset($transByToId[$to])) return $transByToId[$to];
    // fallback: weź pierwsze dostępne (gdyby przeglądarka nie wysłała radio)
    foreach ($transById as $t) return $t;
    return null;
  };

  // heurystyka start/stop
  $pickByNeedles = function(array $toMap, array $needles) use ($transitions): ?array {
    foreach ($transitions as $tr) {
      $to = (int)$tr['to_status_id'];
      $name = mb_strtolower((string)($toMap[$to]['name'] ?? ''));
      foreach ($needles as $n) if (mb_strpos($name, $n) !== false) return $tr;
    }
    return null;
  };

  // centralny zapis zmiany statusu + historia
  $applyTransition = function(array $tr, array $payload) use ($pdo, $id) {
    $uid = currentUserId();
    $to  = (int)$tr['to_status_id'];

    $pdo->beginTransaction();
    try {
      if (tableExists_fix($pdo,'cmms_ticket_status_log')) {
        $ins = $pdo->prepare("
          INSERT INTO cmms_ticket_status_log (ticket_id, from_status_id, to_status_id, user_id, changed_at, comment, reason_code)
          SELECT t.id, t.status_id, :to, :uid, NOW(), :comment, :reason
          FROM cmms_tickets t WHERE t.id = :id
        ");
        $ins->execute([
          ':to'=>$to, ':uid'=>$uid, ':id'=>$id,
          ':comment'=>$payload['comment'] ?? null,
          ':reason'=>$payload['reason_code'] ?? null,
        ]);
      } elseif (tableExists_fix($pdo,'cmms_ticket_status_history')) {
        $ins = $pdo->prepare("
          INSERT INTO cmms_ticket_status_history (ticket_id, old_status_id, new_status_id, changed_by, changed_at, note)
          SELECT t.id, t.status_id, :to, :uid, NOW(), :note FROM cmms_tickets t WHERE t.id = :id
        ");
        $ins->execute([':to'=>$to, ':uid'=>$uid, ':id'=>$id, ':note'=>$payload['comment'] ?? null]);
      }

      $set = "status_id = :to, updated_at = NOW()";
      $params = [':to'=>$to, ':id'=>$id];

      if (!empty($tr['set_resolved_at']) && colExists($pdo,'cmms_tickets','resolved_at')) {
        $set .= ", resolved_at = COALESCE(resolved_at, NOW())";
      }
      if (!empty($tr['set_closed_at']) && colExists($pdo,'cmms_tickets','closed_at')) {
        $set .= ", closed_at = COALESCE(closed_at, NOW())";
      }
      if (!empty($payload['assignee_id']) && colExists($pdo,'cmms_tickets','assignee_id')) {
        $set .= ", assignee_id = :ass";
        $params[':ass'] = (int)$payload['assignee_id'];
      }

      $upd = $pdo->prepare("UPDATE cmms_tickets SET {$set} WHERE id = :id");
      $upd->execute($params);
      $pdo->commit();
      return true;
    } catch (Throwable $e) {
      $pdo->rollBack();
      logError('LIGHT change status fail: '.$e->getMessage());
      return false;
    }
  };

  if ($act === 'change_status') {
    mustHave(['cmms.tickets.change_status','cmms.*','admin.*'], $id);

    $tr = $pickTransition();
    if (!$tr) {
      dbg('No transition matched', ['transition_id'=>($_POST['transition_id'] ?? null), 'to_status_id'=>($_POST['to_status_id'] ?? null)]);
      flash('error','Wybrany status nie jest dozwolony z bieżącego stanu (brak przejścia w workflow).');
      safe_redirect("/light/ticket_show.php?id={$id}"); exit;
    }

    $needComment  = !empty($tr['requires_comment']);
    $needReason   = !empty($tr['requires_reason']);
    $needAssignee = !empty($tr['requires_assignee']);

    $comment = trim((string)($_POST['comment'] ?? ''));
    $reason  = trim((string)($_POST['reason_code'] ?? ''));
    $ass     = isset($_POST['assignee_id']) ? (int)$_POST['assignee_id'] : 0;
    if ($needAssignee && !$ass) $ass = currentUserId(); // auto assign

    if ($needComment && $comment === '') { flash('error','To przejście wymaga komentarza.'); safe_redirect("/light/ticket_show.php?id={$id}"); exit; }
    if ($needReason  && $reason  === '') { flash('error','To przejście wymaga podania powodu.'); safe_redirect("/light/ticket_show.php?id={$id}"); exit; }

    $ok = $applyTransition($tr, ['comment'=>$comment, 'reason_code'=>$reason, 'assignee_id'=>$ass ?: null]);
    flash($ok?'success':'error', $ok ? 'Zmieniono status.' : 'Nie udało się zmienić statusu.');
    safe_redirect("/light/ticket_show.php?id={$id}"); exit;
  }

  if ($act === 'start_work' || $act === 'stop_work') {
    mustHave(['cmms.tickets.change_status','cmms.*','admin.*'], $id);

    if ($act === 'start_work') {
      $tr = $pickByNeedles($toMap, ['realiz','w toku','prac','in progress']);
      if (!$tr) { flash('error','Brak dozwolonego przejścia „Start pracy”.'); safe_redirect("/light/ticket_show.php?id={$id}"); exit; }
      $ok = $applyTransition($tr, ['comment'=>'Start pracy (LIGHT)', 'assignee_id'=>currentUserId()]);
      flash($ok?'success':'error', $ok ? 'Rozpoczęto pracę.' : 'Nie udało się rozpocząć.');
    } else {
      $tr = $pickByNeedles($toMap, ['zamk','zakończ','done','closed']);
      if (!$tr) { flash('error','Brak dozwolonego przejścia „Zakończ”.'); safe_redirect("/light/ticket_show.php?id={$id}"); exit; }
      $ok = $applyTransition($tr, ['comment'=>'Zakończenie pracy (LIGHT)']);
      flash($ok?'success':'error', $ok ? 'Zakończono pracę.' : 'Nie udało się zakończyć.');
    }
    safe_redirect("/light/ticket_show.php?id={$id}"); exit;
  }
}

/* ---------- widok ---------- */
include ROOT_PATH.'includes/layout/header.php';
?>
<main class="content content--light page-narrow">
  <div class="card head">
    <div class="head-top">
      <h1 class="t-title">#<?= (int)$T['id'] ?><?= $T['title'] ? ' — '.h($T['title']) : '' ?></h1>
      <span class="chip" style="--chip: <?= h($T['status_color'] ?: '#e2e8f0') ?>"><?= h($T['status_name'] ?? '—') ?></span>
    </div>
    <div class="muted">Utworzono: <?= h($T['created_at']) ?> • Ostatnia zmiana: <?= h($T['updated_at']) ?></div>
  </div>

  <?php if (!empty($_SESSION['success'])): ?><div class="alert success"><?= h($_SESSION['success']) ?></div><?php unset($_SESSION['success']); endif; ?>
  <?php if (!empty($_SESSION['error'])):   ?><div class="alert error"><?= h($_SESSION['error'])   ?></div><?php unset($_SESSION['error']);   endif; ?>

  <!-- Start/Stop nad zmianą statusu -->
  <div class="card">
    <div class="card-header"><strong>Praca</strong></div>
    <div class="grid2">
      <form method="post" style="margin:0">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="start_work">
        <button class="btn btn-primary btn-lg">▶️ Start</button>
      </form>
      <form method="post" style="margin:0">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="stop_work">
        <button class="btn btn-light btn-lg">⏹️ Stop</button>
      </form>
    </div>
    <small class="muted">Start/Stop tylko zmienia status (worklog dołożymy później).</small>
  </div>

  <!-- Zmiana statusu (stały blok) -->
  <div class="card">
    <div class="card-header">
      <strong>Zmiana statusu</strong>
      <?php if ($workflowId): ?><span class="badge">WF #<?= (int)$workflowId ?></span><?php else: ?><span class="badge">Global</span><?php endif; ?>
    </div>

    <form method="post" action="">
      <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
      <input type="hidden" name="action" value="change_status">
      <input type="hidden" name="to_status_id" id="to_status_id" value="">
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
          </label>
        <?php endforeach; endif; ?>
      </fieldset>

      <div class="field-pair">
        <label for="stComment">Komentarz</label>
        <textarea id="stComment" name="comment" class="input" rows="3" placeholder="Opcjonalnie: dopisz szczegóły…"></textarea>
      </div>

      <div class="field-pair">
        <label for="stReason" id="stReasonLabel">Powód</label>
        <input id="stReason" name="reason_code" class="input" list="stReasonList" placeholder="np. oczekiwanie na części">
        <datalist id="stReasonList"></datalist>
        <div id="reasonChips" class="suggest-chips hidden"></div>
        <small class="muted">Jeśli przejście wymaga przydziału, a nie wybierzesz osoby – przypiszemy <strong>Ciebie</strong>.</small>
      </div>

      <div class="form-actions">
        <button class="btn btn-primary">Zapisz</button>
      </div>
    </form>
  </div>

  <div class="card compact">
    <dl class="def-grid">
      <dt>Typ / Podtyp</dt>
      <dd><?= h(trim(($T['type_name'] ?? '') . ' / ' . ($T['subtype_name'] ?? ''), ' /')) ?: '—' ?></dd>

      <dt>Zasób</dt>
      <dd><?= $T['struktura_name'] ? h($T['struktura_name']) : '—' ?></dd>

      <dt>Priorytet</dt>
      <dd><?= h($T['priority']) ?></dd>

      <dt>Opis</dt>
      <dd style="white-space:pre-wrap"><?= nl2br(h($T['description'] ?? '')) ?></dd>
    </dl>
  </div>

  <div class="card">
    <a class="btn" href="/light/index.php">⬅️ Wróć do LIGHT</a>
    <a class="btn" href="/modules/cmms/zgloszenia/show.php?id=<?= (int)$T['id'] ?>">🔎 Pełny podgląd</a>
  </div>
</main>

<style>
:root { --safe: env(safe-area-inset-bottom, 0px); }
.content--light .page-narrow { max-width: 720px; margin-inline: auto; padding: 8px; }
.alert { padding:10px 12px; border-radius:10px; margin:8px 0; font-size:.95rem; }
.alert.success { background:#e8fff1; border:1px solid #c7f5d9; }
.alert.error { background:#fff1f1; border:1px solid #f5c7c7; }
.card { background:#fff; border:1px solid #e5e7eb; border-radius:14px; padding:12px; margin:10px 0; }
.card.compact { padding:10px; }
.card-header { display:flex; justify-content:space-between; align-items:center; gap:8px; margin-bottom:6px; }
.grid2 { display:grid; grid-template-columns: 1fr 1fr; gap:10px; }
.btn-lg { padding:12px 14px; font-size:1rem; border-radius:12px; }
.muted { color:#6b7280; }
.t-title { font-size: clamp(18px, 4.5vw, 22px); margin:0; }
.head-top { display:flex; justify-content:space-between; align-items:center; gap:8px; }
.chip { display:inline-block; padding:6px 12px; border-radius:999px; background: var(--chip, #eef2ff); font-weight:600; }
.badge { display:inline-block; padding:2px 6px; border-radius:6px; background:#eef; font-size:12px; margin-left:6px; }
.def-grid { display:grid; grid-template-columns: 120px 1fr; gap:4px 10px; font-size: .98rem; }
.def-grid dt { color:#6b7280; }
.suggest-chips { display:flex; flex-wrap:wrap; gap:6px; margin-top:6px; }
.suggest-chip { border:1px solid #e5e7eb; background:#f8fafc; padding:4px 10px; border-radius:999px; cursor:pointer; font-size:12px; }
.suggest-chip:hover { background:#eef2f7; }
</style>

<script>
// ===== podpowiedzi powodów + zsynchronizowanie hidden to_status_id
(function(){
  const radioSelector = 'input[name="transition_id"]';
  const reasonEl  = document.getElementById('stReason');
  const reasonLb  = document.getElementById('stReasonLabel');
  const reasonList  = document.getElementById('stReasonList');
  const reasonChips = document.getElementById('reasonChips');
  const toStatusHidden = document.getElementById('to_status_id');

  const RECENT_PREFIX = 'cmms.reason.';
  const DEFAULTS = { waiting: ['brak części','kontrahent','okno technologiczne','brak dostępu','czekamy na decyzję','przegląd zewnętrzny'] };
  const storeKey = t => RECENT_PREFIX + (t || 'generic');
  function recentLoad(t){ try { const raw = localStorage.getItem(storeKey(t)); const a = raw?JSON.parse(raw):[]; return Array.isArray(a)?a:[]; } catch { return []; } }
  function renderReasonSuggestions(type){
    const t = (type || 'generic');
    let arr = recentLoad(t);
    if (!arr.length && DEFAULTS[t]) arr = DEFAULTS[t];
    reasonList.innerHTML=''; arr.forEach(v=>{const o=document.createElement('option'); o.value=v; reasonList.appendChild(o);});
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

  function getSelectedRadio(){ return document.querySelector(radioSelector + ':checked'); }
  function syncHidden(){ const r = getSelectedRadio(); const v = r?.dataset?.toStatusId || ''; if (toStatusHidden) toStatusHidden.value = v; }
  function applyUI(){
    const r = getSelectedRadio(); if (!r) return;
    const needReason = r.dataset.reqReason === '1';
    const reasonType = (r.dataset.reasonType || '').trim();
    reasonLb.textContent = reasonType ? ('Powód ('+reasonType+')') : 'Powód';
    reasonEl.placeholder = reasonType ? ('Wybierz/wpisz powód ('+reasonType+')') : 'np. oczekiwanie na części';
    renderReasonSuggestions(reasonType || (needReason ? 'waiting' : 'generic'));
    syncHidden();
  }

  document.querySelectorAll(radioSelector).forEach(r => r.addEventListener('change', applyUI));
  applyUI();
})();
</script>

<?php include ROOT_PATH.'includes/layout/footer.php';
