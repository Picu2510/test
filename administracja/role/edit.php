<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

requireLogin();
requirePermission(['roles.manage','roles.edit','roles.*','admin.*','*']);

$pdo = pdo();
if (!isset($pdo) || !($pdo instanceof PDO)) {
    // kompatybilność, jeśli gdzieś masz $db zamiast $pdo
    if (isset($db) && $db instanceof PDO) {
        $pdo = $db;
    } elseif (function_exists('db') && db() instanceof PDO) { // jeśli masz helpera db()
        $pdo = db();
    } else {
        http_response_code(500);
        echo '<pre>Brak połączenia z bazą: $pdo nie jest zainicjalizowane. 
Upewnij się, że używasz głównego init.php (../../../../init.php) i że on tworzy PDO.</pre>';
        exit;
    }
}

$id   = (int)($_GET['id'] ?? 0);
$role = ['id'=>0,'name'=>'','is_system'=>0];

if ($id) {
  $stmt = $pdo->prepare("SELECT id, name, is_system FROM roles WHERE id = ?");
  $stmt->execute([$id]);
  $row = $stmt->fetch(PDO::FETCH_ASSOC);
  if (!$row) { http_response_code(404); exit('Rola nie istnieje'); }
  $role = $row;
}

$pageTitle = $isEdit
  ? sprintf(__('uzytkownicy.role.edit.title') ?: 'Rola – %s', $role['name'] ?? '')
  : (__('uzytkownicy.role.edit.nowaRola') ?: 'Nowa rola');

// wszystkie uprawnienia (grupowanie po module)
$perms = $pdo->query("SELECT id, `key`, `name`, `module` FROM users_permission ORDER BY module, `key`")->fetchAll(PDO::FETCH_ASSOC);
$byModule = [];
foreach ($perms as $p) {
  $mod = $p['module'] ?: explode('.', $p['key'])[0] ?? 'pozostałe';
  $mod = strtolower($mod ?: 'pozostałe');
  $byModule[$mod][] = $p;
}
$modules = array_keys($byModule);
sort($modules);

// aktualne uprawnienia roli
$current = [];
if ($id) {
  $rs = $pdo->prepare("SELECT permission_id FROM users_role_permission WHERE role_id = ?");
  $rs->execute([$id]);
  $current = array_map('intval', $rs->fetchAll(PDO::FETCH_COLUMN));
}

include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>
<main class="content permissions onecol">
  <form method="post" action="save.php">
    <?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= (int)$role['id'] ?>">

    <section class="card">
      <h2>🧩 <?= __('uzytkownicy.role.list.daneRoli') ?: 'Dane roli' ?></h2>
      <div class="form-grid">
        <div class="field">
          <label><?= __('uzytkownicy.role.list.nazwa') ?: 'Nazwa' ?></label>
          <input type="text" name="name" value="<?= htmlspecialchars($role['name']) ?>" required>
        </div>
        <div class="field">
          <label><?= __('uzytkownicy.role.list.systemowa') ?: 'Systemowa' ?></label>
          <input type="checkbox" disabled <?= (int)$role['is_system'] ? 'checked':'' ?>>
          <small class="muted"><?= __('uzytkownicy.role.list.nieMoznaUsuwac') ?: 'Ról systemowych nie można usuwać.' ?></small>
        </div>
      </div>
    </section>

    <section class="card">
      <h2>🔐 <?= __('uzytkownicy.role.list.uprawnieniaRoli') ?: 'Uprawnienia roli' ?></h2>

      <div class="toolbar">
        <div class="flex-1-320">
          <label for="perm-search" class="muted d-block"><?= __('uzytkownicy.role.list.szukajUprawnienia') ?: 'Szukaj uprawnienia' ?></label>
          <input id="perm-search" type="search" class="w-100" placeholder="np. cmms, view, manage">
        </div>
      </div>

      <?php foreach ($modules as $mod):
            $items = $byModule[$mod] ?? []; $count = count($items); ?>
      <details class="card" data-module="<?= htmlspecialchars($mod) ?>" open>
        <summary>
          <span><?= strtoupper(htmlspecialchars($mod)) ?> <span class="muted">(<?= (int)$count ?>)</span></span>
          <span class="summary-actions">
            <button type="button" class="btn btn-sm mod-check" data-mod="<?= htmlspecialchars($mod) ?>" data-state="all"><?= __('uzytkownicy.role.list.zaznaczModul') ?: 'Zaznacz moduł' ?></button>
            <button type="button" class="btn btn-sm mod-check" data-mod="<?= htmlspecialchars($mod) ?>" data-state="none"><?= __('uzytkownicy.role.list.odznaczModul') ?: 'Odznacz moduł' ?></button>
          </span>
        </summary>

        <div class="table-wrapper mt-05">
          <table class="table">
            <thead>
              <tr><th class="col-perm"><?= __('uzytkownicy.role.list.uprawnienia') ?: 'Uprawnienie' ?></th><th class="col-state"><?= __('uzytkownicy.role.list.wybor') ?: 'Wybór' ?></th></tr>
            </thead>
            <tbody>
              <?php foreach ($items as $p): $pid = (int)$p['id']; ?>
              <tr data-module="<?= htmlspecialchars($mod) ?>" data-text="<?= htmlspecialchars(strtolower(($p['name'] ?? '').' '.$p['key'])) ?>">
                <td>
                  <?= htmlspecialchars($p['name']) ?>
                  <div class="muted"><code><?= htmlspecialchars($p['key']) ?></code></div>
                </td>
                <td>
                  <label class="checkbox">
                    <input type="checkbox" name="perm[]" value="<?= $pid ?>" <?= in_array($pid, $current, true)?'checked':'' ?>>
                    <?= __('uzytkownicy.role.list.wlacz') ?: 'Włącz' ?>
                  </label>
                </td>
              </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </details>
      <?php endforeach; ?>
    </section>

    <div class="form-actions sticky">
      <a class="btn btn-secondary" href="list.php">↩️ <?= __('uzytkownicy.role.list.powrot') ?: 'Powrót' ?></a>
      <button class="btn btn-primary">💾 <?= __('uzytkownicy.role.list.zapiszRole') ?: 'Zapisz rolę' ?></button>
    </div>
  </form>
</main>

<script src="role_edit.js" defer></script>
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
