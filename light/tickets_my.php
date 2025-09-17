<?php
// /light/tickets_my.php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';
requireLogin();
requirePermission(['cmms.tickets.view','cmms.*','admin.*']);

/** @var PDO $pdo */
$pdo = pdo();
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if (!function_exists('h')) {
  function h(?string $s): string { return htmlspecialchars((string)$s, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }
}
if (!function_exists('currentUserId')) {
  function currentUserId(): int {
    if (function_exists('currentUser')) {
      $u = currentUser();
      if (is_array($u) && isset($u['id'])) return (int)$u['id'];
    }
    return isset($_SESSION['user']['id']) ? (int)$_SESSION['user']['id'] : 0;
  }
}

/* ---------- helpers ---------- */
function findCol(PDO $pdo, array $candidates): ?string {
  // sprawdzamy w cmms_tickets
  foreach ($candidates as $n) {
    $sql = "SHOW COLUMNS FROM `cmms_tickets` LIKE " . $pdo->quote($n);
    $res = $pdo->query($sql);
    if ($res && $res->fetch(PDO::FETCH_ASSOC)) return $n;
  }
  return null;
}
function findColIn(PDO $pdo, string $table, array $candidates): ?string {
  foreach ($candidates as $n) {
    $sql = "SHOW COLUMNS FROM `{$table}` LIKE " . $pdo->quote($n);
    $res = $pdo->query($sql);
    if ($res && $res->fetch(PDO::FETCH_ASSOC)) return $n;
  }
  return null;
}
function normalize_hex(?string $c): ?string {
  if (!$c) return null;
  $c = trim($c);
  if ($c === '') return null;
  // akceptujemy #rgb/#rrggbb lub rrggbb
  if (preg_match('/^#?[0-9a-f]{3}([0-9a-f]{3})?$/i', $c)) {
    if ($c[0] !== '#') $c = '#'.$c;
    return strtoupper($c);
  }
  // inne formaty (rgb(), nazwy) – zwróć tak jak jest
  return $c;
}
function contrast_for_hex(string $hex): string {
  // dla #RRGGBB policz kontrast (czarny/biały)
  if (preg_match('/^#([0-9A-F]{6})$/i', $hex, $m)) {
    $r = hexdec(substr($m[1],0,2));
    $g = hexdec(substr($m[1],2,2));
    $b = hexdec(substr($m[1],4,2));
    $yiq = (($r*299)+($g*587)+($b*114))/1000;
    return ($yiq >= 140) ? '#111' : '#fff';
  }
  // dla nietypowych formatów – domyślnie biała
  return '#fff';
}

/* ---------- parametry ---------- */
$uid = (int)currentUserId();
$onlyOpen = (!empty($_GET['only_open']) && $_GET['only_open'] === '1');

/* ---------- 1) wykryj kolumny w cmms_tickets ---------- */
$col = [
  'created_by'      => findCol($pdo, ['created_by','utworzyl_id','autor_id']),
  'assigned_user'   => findCol($pdo, ['assigned_user_id','przypisany_user_id']),
  'assigned_group'  => findCol($pdo, ['assigned_group_id','group_id','grupa_id']),
  'status'          => findCol($pdo, ['status_id','status']),
  'type'            => findCol($pdo, ['type_id','typ_id']),
  'subtype'         => findCol($pdo, ['subtype_id','podtyp_id']),
  'structure'       => findCol($pdo, ['structure_id','struktura_id','lokalizacja_id','element_id']),
  'opis'            => findCol($pdo, ['opis','description']),
  'created_at'      => findCol($pdo, ['created_at','data_utworzenia']),
  'updated_at'      => findCol($pdo, ['updated_at','data_aktualizacji']),
];
if (!$col['created_by']) { throw new RuntimeException('Brak kolumny created_by/utworzyl_id w cmms_tickets'); }
if (!$col['status'])     { $col['status']     = 'status_id'; }
if (!$col['opis'])       { $col['opis']       = 'opis'; }
if (!$col['created_at']) { $col['created_at'] = 'created_at'; }
if (!$col['updated_at']) { $col['updated_at'] = 'updated_at'; }

/* ---------- 2) wykryj kolumny nazw/kolorów w słownikach ---------- */
$STATUS_NAME_COL  = findColIn($pdo, 'cmms_statuses',        ['name','nazwa','label']) ?: 'name';
$STATUS_COLOR_COL = findColIn($pdo, 'cmms_statuses',        ['color','kolor','color_hex','kolor_hex','bg_color']);
$TYPE_NAME_COL    = findColIn($pdo, 'cmms_ticket_types',    ['name','nazwa','label']) ?: 'name';
$SUBTYPE_NAME_COL = findColIn($pdo, 'cmms_ticket_subtypes', ['name','nazwa','label']) ?: 'name';
$STRUCT_NAME_COL  = findColIn($pdo, 'cmms_struktura',       ['nazwa','name','label']) ?: 'nazwa';

/* ---------- 3) grupy użytkownika ---------- */
$userGroupIds = [];
if ($col['assigned_group']) {
  $qg = $pdo->prepare("
    SELECT gu.group_id
    FROM cmms_group_user gu
    INNER JOIN cmms_group g ON g.id = gu.group_id
    WHERE gu.user_id = :uid
  ");
  $qg->execute([':uid'=>$uid]);
  $userGroupIds = array_map('intval', array_column($qg->fetchAll(PDO::FETCH_ASSOC), 'group_id'));
}

/* ---------- 4) WHERE: moje + przypisane ---------- */
$where  = [];
$params = [':uid'=>$uid];
$where[] = "t.`{$col['created_by']}` = :uid";
if ($col['assigned_user'])  $where[] = "t.`{$col['assigned_user']}` = :uid";
if ($col['assigned_group'] && $userGroupIds) {
  $keys = [];
  foreach ($userGroupIds as $i => $gid) { $k=":g{$i}"; $keys[]=$k; $params[$k]=$gid; }
  $where[] = "t.`{$col['assigned_group']}` IN (".implode(',', $keys).")";
}
if (!$where) { $where[] = "t.`{$col['created_by']}` = :uid"; }

$statusFilter = '';
if ($onlyOpen) {
  $statusFilter = " AND NOT EXISTS (
    SELECT 1 FROM cmms_statuses s2
    WHERE s2.id = t.`{$col['status']}`
      AND LOWER(COALESCE(NULLIF(TRIM(s2.`{$STATUS_NAME_COL}`),''), CONCAT('status#',s2.id)))
          REGEXP '(zamk|zako|done|closed)'
  )";
}

/* ---------- 5) SELECT + JOINy ---------- */
$select = [
  "t.id",
  "t.`{$col['opis']}` AS opis",
  "t.`{$col['created_at']}` AS created_at",
  "t.`{$col['updated_at']}` AS updated_at",
  "t.`{$col['status']}` AS status_id",
];
$joins  = [];
$labels = [];

// type/subtype/structure
if ($col['type']) {
  $select[] = "t.`{$col['type']}` AS type_id";
  $joins[]  = "LEFT JOIN cmms_ticket_types tt ON tt.id = t.`{$col['type']}`";
  $labels[] = "COALESCE(NULLIF(TRIM(tt.`{$TYPE_NAME_COL}`),''), CONCAT('Typ #', t.`{$col['type']}`)) AS type_name";
} else $labels[] = "NULL AS type_name";

if ($col['subtype']) {
  $select[] = "t.`{$col['subtype']}` AS subtype_id";
  $joins[]  = "LEFT JOIN cmms_ticket_subtypes st ON st.id = t.`{$col['subtype']}`";
  $labels[] = "COALESCE(NULLIF(TRIM(st.`{$SUBTYPE_NAME_COL}`),''), CONCAT('Podtyp #', t.`{$col['subtype']}`)) AS subtype_name";
} else $labels[] = "NULL AS subtype_name";

if ($col['structure']) {
  $select[] = "t.`{$col['structure']}` AS structure_id";
  $joins[]  = "LEFT JOIN cmms_struktura cs ON cs.id = t.`{$col['structure']}`";
  $labels[] = "COALESCE(NULLIF(TRIM(cs.`{$STRUCT_NAME_COL}`),''), CONCAT('Lokalizacja #', t.`{$col['structure']}`)) AS structure_name";
} else $labels[] = "NULL AS structure_name";

// status label + kolor
$joins[]  = "LEFT JOIN cmms_statuses ss ON ss.id = t.`{$col['status']}`";
$labels[] = "COALESCE(NULLIF(TRIM(ss.`{$STATUS_NAME_COL}`),''), CONCAT('Status #', t.`{$col['status']}`)) AS status_name";
if ($STATUS_COLOR_COL) {
  $select[] = "ss.`{$STATUS_COLOR_COL}` AS status_color";
}

$selectSql = implode(",\n    ", array_merge($select, $labels));

$sql = "
  SELECT
    {$selectSql}
  FROM cmms_tickets t
  ".implode("\n  ", $joins)."
  WHERE (".implode(' OR ', $where).") {$statusFilter}
  ORDER BY COALESCE(t.`{$col['updated_at']}`, t.`{$col['created_at']}`) DESC
  LIMIT 100
";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

/* ---------- 6) Widok ---------- */
include ROOT_PATH.'includes/layout/header.php';
?>
<main class="content content--light page-narrow">
  <div class="card">
    <h1>📋 Moje zgłoszenia</h1>
    <form method="get" class="inline">
      <label style="display:inline-flex;align-items:center;gap:.5rem;">
        <input type="checkbox" name="only_open" value="1" <?= $onlyOpen?'checked':''; ?> onchange="this.form.submit()">
        <span>Tylko otwarte</span>
      </label>
    </form>
    <p><small>Ostatnie 100 zgłoszeń: utworzone przez Ciebie, przypisane do Ciebie lub do Twoich grup.</small></p>
  </div>

  <?php if (!$rows): ?>
    <div class="card"><p>Brak zgłoszeń do wyświetlenia.</p></div>
  <?php else: ?>
    <div class="card">
      <div class="light-list">
        <?php foreach ($rows as $r):
          $raw = isset($r['status_color']) ? (string)$r['status_color'] : '';
          $hex = normalize_hex($raw);
          $style = '';
          if ($raw !== '') {
            $clr = $hex ?: $raw;                 // akceptuj rgb()/nazwy jeśli ktoś tak trzyma
            $txt = $hex ? contrast_for_hex($hex) : '#fff';
            $style = ' style="--st: '.h($clr).'; --stc: '.h($txt).'";';
          }
        ?>
		
			<a class="light-list__item"
			   href="<?= ROOT_URL ?>modules/cmms/zgloszenia/show_light.php?id=<?= (int)$r['id'] ?>"
			   rel="external" data-hardlink="1" <?= $style ?>>
            <div class="light-list__line1">
              <strong>#<?= (int)$r['id'] ?></strong>
              <span class="badge"><?= h((string)$r['status_name']) ?></span>
            </div>
            <div class="light-list__line2">
              <?= h((string)($r['type_name'] ?? '—')) ?> / <?= h((string)($r['subtype_name'] ?? '—')) ?>
            </div>
            <div class="light-list__line3">
              <?= h((string)($r['structure_name'] ?? '—')) ?>
            </div>
            <div class="light-list__meta">
              <span>utw.: <?= h((string)$r['created_at']) ?></span>
              <span>akt.: <?= h((string)$r['updated_at']) ?></span>
            </div>
            <?php if (!empty($r['opis'])): ?>
              <div class="light-list__desc"><?= h(mb_strimwidth((string)$r['opis'], 0, 120, '…', 'UTF-8')) ?></div>
            <?php endif; ?>
          </a>
        <?php endforeach; ?>
      </div>
    </div>
  <?php endif; ?>

  <div class="card">
    <?php if (checkAccess(['cmms.tickets.create','cmms.*','admin.*'])): ?>
      <a class="btn btn-primary btn-lg" href="/modules/cmms/zgloszenia/edit.php?return=<?= urlencode('/light/tickets_my.php') ?>">➕ Dodaj zgłoszenie</a>
    <?php endif; ?>
    <a class="btn" href="/light/index.php">⬅️ Wróć do LIGHT</a>
  </div>
</main>

<style>
.content--light .page-narrow { max-width: 720px; margin-inline: auto; }
.light-list { display: grid; gap: 10px; }
.light-list__item {
  display: block;
  padding: 12px 12px 12px 16px;
  border: 1px solid var(--color-border,#dee2e6);
  border-radius: 12px;
  text-decoration: none; color: inherit; background: #fff;
  position: relative;
  /* kolor wg statusu */
  border-left: 6px solid var(--st, var(--color-border,#dee2e6));
}
.light-list__item:active { transform: scale(0.998); }
.light-list__line1 { display:flex; justify-content:space-between; align-items:center; margin-bottom:4px; }
.light-list__line2 { font-weight:600; }
.light-list__line3 { color:#666; font-size:.95rem; }
.light-list__meta { display:flex; gap:12px; color:#888; font-size:.85rem; margin-top:6px; }
.light-list__desc { margin-top:6px; color:#444; }
.badge { background: var(--st, #eef); color: var(--stc, #223); padding:3px 8px; border-radius:999px; }
</style>

<?php include ROOT_PATH.'includes/layout/footer.php';
