<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

requireLogin();
requirePermission(['roles.view','roles.*','admin.*','*']);

$pageTitle = __('uzytkownicy.role.list.tytul') ?: 'Role – lista';
$pdo = pdo();

$rows = $pdo->query("
  SELECT r.id, r.name, r.is_system,
         (SELECT COUNT(*) FROM users_role ur WHERE ur.role_id = r.id)           AS users_cnt,
         (SELECT COUNT(*) FROM users_role_permission rp WHERE rp.role_id = r.id) AS perms_cnt
  FROM roles r
  ORDER BY r.is_system DESC, r.name
")->fetchAll(PDO::FETCH_ASSOC);

include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>
<main class="content">
  <div class="toolbar">
    <a class="btn btn-primary" href="edit.php">➕ <?= __('uzytkownicy.role.list.dodaj') ?: 'Nowa rola' ?></a>
  </div>

  <div class="table-wrapper">
    <table class="table">
      <thead>
        <tr>
          <th><?= __('uzytkownicy.role.list.nazwa') ?: 'Nazwa' ?></th>
          <th><?= __('uzytkownicy.role.list.uzytkownicy') ?: 'Użytkownicy' ?></th>
          <th><?= __('uzytkownicy.role.list.uprawnienia') ?: 'Uprawnienia' ?></th>
          <th><?= __('uzytkownicy.role.list.systemowa') ?: 'Systemowa' ?></th>
          <th><?= __('uzytkownicy.role.list.akcje') ?: 'Akcje' ?></th>
        </tr>
      </thead>
      <tbody>
      <?php foreach ($rows as $r): ?>
        <tr>
          <td><?= htmlspecialchars($r['name']) ?></td>
          <td><?= (int)$r['users_cnt'] ?></td>
          <td><?= (int)$r['perms_cnt'] ?></td>
          <td><?= (int)$r['is_system'] ? 'tak' : 'nie' ?></td>
          <td>
            <a class="btn btn-sm" href="edit.php?id=<?= (int)$r['id'] ?>">✏️ <?= __('uzytkownicy.role.list.edytuj') ?: 'Edytuj' ?></a>
            <?php if (!(int)$r['is_system']): ?>
              <form method="post" action="delete.php"  action="delete.php" class="inline-form ml-025">
                <?= csrf_field() ?>
                <input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
                <button class="btn btn-sm btn-danger" onclick="return confirm('Usunąć rolę?')">🗑 <?= __('uzytkownicy.role.list.usun') ?: 'Usuń' ?></button>
              </form>
            <?php else: ?>
              <span class="muted">🛡 <?= __('uzytkownicy.role.list.chroniona') ?: 'chroniona' ?></span>
            <?php endif; ?>
          </td>
        </tr>
      <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</main>
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
