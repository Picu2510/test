<?php
declare(strict_types=1);

require_once __DIR__ . '/../../../includes/init.php';

requireLogin();
requirePermission(['users.permissions','users.edit','users.*','admin.*','*']);
if ($_SERVER['REQUEST_METHOD'] === 'POST') csrf_verify($_POST['csrf'] ?? null);

/** @var PDO $pdo */
$pdo = pdo();

$userId = (int)($_GET['id'] ?? 0);
if ($userId <= 0) { header('Location: list.php'); exit; }

/* 1) Użytkownik + flagi (aliasy → zawsze 0/1) */
$stmt = $pdo->prepare("
  SELECT 
    u.id, u.login, u.imie, u.nazwisko,
    COALESCE(u.access_cmms,0)        AS access_cmms,
    COALESCE(u.access_mes,0)         AS access_mes,
    COALESCE(u.access_kompetencje,0) AS access_kompetencje
  FROM users u
  WHERE u.id = :id
");
$stmt->execute([':id' => $userId]);
$users = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$users) { http_response_code(404); exit('Użytkownik nie istnieje'); }

/* 2) Tytuł */
$displayName = trim(($users['imie'] ?? '') . ' ' . ($users['nazwisko'] ?? ''));
if ($displayName === '') $displayName = (string)($users['login'] ?? ('Użytkownik #'.$userId));
$pageTitle = 'Użytkownicy – uprawnienia: ' . $displayName;

/* 3) Role i role użytkownika */
$roles = $pdo->query("SELECT id, name FROM roles ORDER BY name")->fetchAll(PDO::FETCH_ASSOC);

$stmt = $pdo->prepare("SELECT role_id FROM users_role WHERE user_id = :uid");
$stmt->execute([':uid' => $userId]);
$userRoleIds = array_map('intval', array_column($stmt->fetchAll(PDO::FETCH_ASSOC), 'role_id'));
$currentRoleId = $userRoleIds[0] ?? 0; // <- jedna, bieżąca rola

/* 4) Uprawnienia pogrupowane po module (slug) */
$perms = $pdo->query("SELECT id, `key`, `name`, `module` FROM users_permission ORDER BY module, `key`")->fetchAll(PDO::FETCH_ASSOC);

$byModule = [];
foreach ($perms as $p) {
    $m = $p['module'] ?: (explode('.', $p['key'])[0] ?? '');
    $slug = strtolower(trim($m));
    if ($slug === '') $slug = 'pozostałe';
    $p['_mod'] = $slug;
    $byModule[$slug][] = $p;
}
$modules = array_keys($byModule);
sort($modules);

/* 5) Nadpisania per użytkownik */
$stmt = $pdo->prepare("SELECT permission_id, `allow` FROM users_user_permission WHERE user_id = :uid");
$stmt->execute([':uid' => $userId]);
$overridesMap = [];
foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
  $overridesMap[(int)$row['permission_id']] = (int)$row['allow']; // 1 allow, 0 deny
}

/* 6) Mapa role → permission_id (z ROZWINIĘCIEM wildcardów '*.') */
$rolePerms = [];

// słowniki uprawnień
$permById  = [];
$permByKey = [];
foreach ($perms as $pp) {
  $pid = (int)$pp['id'];
  $permById[$pid] = $pp['key'];
  $permByKey[$pp['key']] = ['id' => $pid, 'key' => $pp['key']];
}
$startsWith = static function(string $s, string $prefix): bool {
  return strncmp($s, $prefix, strlen($prefix)) === 0;
};
$expandKeyToIds = static function(string $key) use ($permByKey, $perms, $startsWith): array {
  if (substr($key, -2) !== '.*') {
    return isset($permByKey[$key]) ? [(int)$permByKey[$key]['id']] : [];
  }
  $prefix = substr($key, 0, -1); // 'cmms.' z 'cmms.*'
  $ids = [];
  foreach ($perms as $p) {
    if ($startsWith($p['key'], $prefix)) $ids[] = (int)$p['id'];
  }
  return array_values(array_unique($ids));
};

// prefer users_role_permission
try {
  $rows = $pdo->query("SELECT role_id, permission_id FROM users_role_permission")->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) { $rows = []; }

// fallback: role_permissions (perm_key/permission_id)
if (empty($rows)) {
  try {
    $rows = $pdo->query("
      SELECT rp.role_id,
             COALESCE(rp.permission_id, p.id) AS permission_id,
             COALESCE(rp.perm_key, p.`key`)   AS perm_key
      FROM role_permissions rp
      LEFT JOIN users_permission p ON p.`key` = rp.perm_key
      WHERE COALESCE(rp.permission_id, p.id) IS NOT NULL
    ")->fetchAll(PDO::FETCH_ASSOC);
  } catch (Throwable $e) { $rows = []; }
}

foreach ($rows as $rp) {
  $rid = (int)$rp['role_id'];
  $pid = isset($rp['permission_id']) ? (int)$rp['permission_id'] : 0;
  $key = $rp['perm_key'] ?? ($permById[$pid] ?? null);
  if ($key === null) continue;
  $ids = $expandKeyToIds($key);
  if (empty($ids) && $pid) $ids = [$pid];
  foreach ($ids as $id) $rolePerms[$rid][] = (int)$id;
}
foreach ($rolePerms as $rid => $list) {
  $rolePerms[$rid] = array_values(array_unique(array_map('intval', $list)));
}

/* 7) Szablony */
include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>
<main class="content permissions onecol">

  <?php if (!empty($_GET['saved'])): ?>
    <div class="alert alert-success">Zapisano zmiany uprawnień.</div>
  <?php endif; ?>

  <form method="post" action="save_permissions.php">
    <input type="hidden" name="csrf" value="<?= htmlspecialchars((string)csrf_token(), ENT_QUOTES, 'UTF-8') ?>">
    <input type="hidden" name="user_id" value="<?= (int)$users['id'] ?>">

    <!-- Sekcja 1: Dostęp do modułów -->
    <details class="card" open>
      <summary>🔑 Dostęp do modułów</summary>
      <div class="module-flags">
        <label class="module-flag">
          <input type="checkbox" name="access_cmms" value="1" <?= ((int)$users['access_cmms']===1?'checked':'') ?>>
          <span>CMMS<small>Utrzymanie ruchu</small></span>
        </label>
        <label class="module-flag">
          <input type="checkbox" name="access_mes" value="1" <?= ((int)$users['access_mes']===1?'checked':'') ?>>
          <span>MES<small>Rejestracja produkcji</small></span>
        </label>
        <label class="module-flag">
          <input type="checkbox" name="access_kompetencje" value="1" <?= ((int)$users['access_kompetencje']===1?'checked':'') ?>>
          <span>Kompetencje<small>Matryce i szkolenia</small></span>
        </label>
      </div>
      <p class="muted">Flagi sterują widocznością modułów. Uprawnienia szczegółowe poniżej.</p>
    </details>

    <!-- Sekcja 2: Role -->
	<details class="card" open>
	  <summary>👥 Rola użytkownika</summary>
	  <div class="form-grid">
		<select name="role_id" class="w-100">
		  <option value="">— brak roli —</option>
		  <?php foreach ($roles as $r): ?>
			<option value="<?= (int)$r['id'] ?>" <?= ((int)$r['id']===(int)$currentRoleId?'selected':'') ?>>
			  <?= htmlspecialchars($r['name']) ?>
			</option>
		  <?php endforeach; ?>
		</select>
	  </div>
	  <p class="muted">Rola nadaje zestaw uprawnień. Nadpisania poniżej mogą rozszerzać (Allow) lub ograniczać (Deny).</p>
	</details>

    <!-- Sekcja 3: Nadpisania -->
    <details class="card" open>
      <summary>⚙️ Nadpisania (Allow / Deny / Dziedzicz)</summary>

      <div class="toolbar">
        <div class="flex-1-320">
          <label for="perm-search" class="muted d-block">Szukaj uprawnienia</label>
          <input id="perm-search" type="search" placeholder="np. zgłoszenia, statusy.manage, podgląd" class="w-100">
        </div>
        <label class="nowrap">
          <input type="checkbox" id="toggle-visible"> Zaznacz/odznacz widoczne (Allow / Dziedzicz)
        </label>
        <button type="button" class="btn" id="btn-allow-visible">Zezwól (widoczne)</button>
        <button type="button" class="btn" id="btn-deny-visible">Zabroń (widoczne)</button>
        <button type="button" class="btn" id="btn-inherit-visible">Dziedzicz (widoczne)</button>
      </div>

      <?php foreach ($modules as $mod): 
            $items = $byModule[$mod] ?? [];
            $count = count($items);
      ?>
      <details class="card" data-module="<?= htmlspecialchars($mod) ?>" open>
        <summary>
          <span><?= htmlspecialchars(strtoupper($mod)) ?> <span class="muted">(<?= (int)$count ?>)</span></span>
        </summary>
          <span class="summary-actions">
            <button type="button" class="btn btn-sm group-allow"   data-group="<?= htmlspecialchars($mod) ?>">Zezwól grupę</button>
            <button type="button" class="btn btn-sm group-deny"    data-group="<?= htmlspecialchars($mod) ?>">Zabroń grupę</button>
            <button type="button" class="btn btn-sm group-inherit" data-group="<?= htmlspecialchars($mod) ?>">Dziedzicz grupę</button>
          </span>

        <div class="table-wrapper mt-05">
          <table class="table">
            <thead>
              <tr>
                <th class="col-perm">Uprawnienie</th>
				<th class="col-state">Stan</th>
              </tr>
            </thead>
            <tbody>
            <?php foreach ($items as $p):
                $pid    = (int)$p['id'];
                $state  = array_key_exists($pid, $overridesMap) ? ($overridesMap[$pid] ? 'allow' : 'deny') : 'inherit';
                $text   = strtolower(($p['name'] ?? '') . ' ' . ($p['key'] ?? ''));
            ?>
              <tr data-module="<?= htmlspecialchars($mod) ?>" data-text="<?= htmlspecialchars($text) ?>" data-pid="<?= $pid ?>">
                <td>
                  <?= htmlspecialchars($p['name']) ?>
                  <div class="muted"><code><?= htmlspecialchars($p['key']) ?></code></div>
                </td>
                <td>
                  <label class="radio mr-05">
                    <input type="radio" name="perm_override[<?= $pid ?>]" value="inherit" <?= $state==='inherit'?'checked':'' ?>> Dziedzicz
                  </label>
                  <label class="radio mr-05">
                    <input type="radio" name="perm_override[<?= $pid ?>]" value="allow"   <?= $state==='allow'  ?'checked':'' ?>> Allow
                  </label>
                  <label class="radio">
                    <input type="radio" name="perm_override[<?= $pid ?>]" value="deny"    <?= $state==='deny'   ?'checked':'' ?>> Deny
                  </label>
                  <span class="by-role-badge" hidden>z roli</span>
                </td>
              </tr>
            <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </details>
      <?php endforeach; ?>
    </details>

    <div class="form-actions sticky">
      <a class="btn btn-secondary" href="../uzytkownicy/list.php">↩️ Powrót</a>
      <button type="submit" name="save" value="1" class="btn btn-primary">💾 Zapisz zmiany</button>
    </div>
  </form>
</main>

<!-- Bez inline JS: dane → data-*; skrypt zewnętrzny -->
<div id="permData"
     data-role-perms='<?= htmlspecialchars(json_encode($rolePerms), ENT_QUOTES, "UTF-8") ?>'
     data-preselected-roles='<?= htmlspecialchars(json_encode(array_values($userRoleIds)), ENT_QUOTES, "UTF-8") ?>'></div>

<script src="edit_permissions.js" defer></script>
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
