<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

/* ---------- auth / perms ---------- */
requireLogin();
requirePermission(['users.view','users.*','admin.*','*']);
$activeModule = 'admin';
$pageTitle = __('uzytkownicy.list.tytul') ?: 'Użytkownicy';


// Helpers -------------------------------------------------------------------------------------------------

if (!function_exists('safe_redirect')) {
  function safe_redirect(string $url): void {
    if (!headers_sent()) { header('Location: '.$url); exit; }
    echo '<meta http-equiv="refresh" content="0;url='.htmlspecialchars($url, ENT_QUOTES).'">';
    echo '<script>location.replace('.json_encode($url).');</script>'; exit;
  }
}


// Body -----------------------------------------------------------------------------------------------------

$q = trim($_GET['q'] ?? '');
$onlyActive = isset($_GET['active']) ? (int)$_GET['active'] : -1; // -1 = wszyscy
$perPage = max(5, min(50, (int)($_GET['pp'] ?? 15)));
$page = max(1, (int)($_GET['p'] ?? 1));
$offset = ($page-1)*$perPage;

$pdo = pdo();
$where = [];
$args = [];

if ($q !== '') {
	$where[] = "(LOWER(login) LIKE ? OR LOWER(email) LIKE ? OR LOWER(imie) LIKE ? OR LOWER(nazwisko) LIKE ?)";
	$qq = '%'.mb_strtolower($q).'%';
	array_push($args, $qq, $qq, $qq, $qq);
}
if ($onlyActive !== -1) {
	$where[] = "aktywny = ?";
	$args[] = $onlyActive;
}
$wsql = $where ? ('WHERE '.implode(' AND ', $where)) : '';

$total = (int)$pdo->prepare("SELECT COUNT(*) FROM users $wsql")->execute($args) ?: 0;
$stm = $pdo->prepare("
	SELECT u.id, u.login, u.imie, u.nazwisko, u.email, u.aktywny, u.language,
         r.name AS role_name
	FROM users u
	LEFT JOIN roles r ON r.id = u.role_id
	$wsql
	ORDER BY nazwisko, imie
	LIMIT $perPage OFFSET $offset");
$stm->execute($args);
$rows = $stm->fetchAll();

/* ---------- widok ---------- */
include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>
<main class="content">
	<div class="page-actions">
		<?php if (hasAccess(['users.edit','users.admin'], false)): ?>
			<a href="/modules/administracja/uzytkownicy/edit.php" class="btn btn-primary">
				➕ <?= __('uzytkownicy.list.add') ?: 'Dodaj użytkownika' ?>
			</a>
		<?php endif; ?>
	</div>

	<div class="card">
		<div class="card-header">
			<?= __('uzytkownicy.list.tytul') ?: 'Użytkownicy' ?>
		</div>
		
		<div class="card-body">

		<form method="get" class="inline" action="">
			<input type="text" name="q" placeholder="<?= __('uzytkownicy.list.szukaj') ?: 'Szukaj: login, imię, nazwisko, email' ?>" value="<?= htmlspecialchars($q) ?>">
			<select name="active">
				<option value="-1" <?= $onlyActive===-1?'selected':'' ?>><?= __('uzytkownicy.list.wszyscy') ?: 'Wszyscy' ?></option>
				<option value="1"  <?= $onlyActive===1?'selected':''  ?>><?= __('uzytkownicy.list.aktywni') ?: 'Aktywni' ?></option>
				<option value="0"  <?= $onlyActive===0?'selected':''  ?>><?= __('uzytkownicy.list.nieaktywni') ?: 'Nieaktywni' ?></option>
			</select>
			<button class="btn"><?= __('uzytkownicy.list.filtruj') ?: 'Filtruj' ?></button>
		</form>

		  <!-- 👇 wrapper dla przewijania poziomego -->
		<div class="table-wrapper">
			<table class="table">
				<thead>
					<tr>
						<th><?= __('uzytkownicy.list.tab.nazwiskoImie') ?: 'Nazwisko i imię' ?></th>
						<th><?= __('uzytkownicy.list.tab.login') ?: 'Login' ?></th>
						<th><?= __('uzytkownicy.list.tab.email') ?: 'E-mail' ?></th>
						<th><?= __('uzytkownicy.list.tab.rola') ?: 'Rola' ?></th>
						<th><?= __('uzytkownicy.list.tab.jezyk') ?: 'Język' ?></th>
						<th><?= __('uzytkownicy.list.tab.aktywny') ?: 'Aktywny' ?></th>
						<th><?= __('uzytkownicy.list.tab.akcje') ?: 'Akcje' ?></th>
					</tr>
				</thead>
					<tbody>
						<?php foreach ($rows as $r): ?>
						<tr>
							<td><?= htmlspecialchars($r['nazwisko'].' '.$r['imie']) ?></td>
							<td><?= htmlspecialchars($r['login']) ?></td>
							<td><?= htmlspecialchars($r['email'] ?? '') ?></td>
							<td><?= htmlspecialchars($r['role_name'] ?? '-') ?></td>
							<td><?= strtoupper(htmlspecialchars($r['language'] ?? 'pl')) ?></td>
							<td><?= $r['aktywny'] ? '✅' : '🚫' ?></td>
							<td class="inline">
							<?php if (hasAccess(['users.edit','users.admin'], false)): ?>
								<a class="btn btn-secondary btn-sm" href="/modules/administracja/uzytkownicy/edit.php?id=<?= (int)$r['id'] ?>">✏️ <?= __('global.edytuj') ?: 'Edytuj' ?></a>
							<?php endif; ?>
							
							<?php if (hasAccess(['users.edit','users.admin'], false)): ?>
								<a class="btn btn-secondary btn-sm" href="/modules/administracja/uzytkownicy/edit_permissions.php?id=<?= (int)$r['id'] ?>">🧩 <?= __('uzytkownicy.list.tab.edytujUprawnienia') ?: 'Edytuj uprawnienia' ?></a>
							<?php endif; ?>

							<?php if (hasAccess(['users.edit','users.admin'], false)): ?>
								<form method="post" action="/modules/administracja/uzytkownicy/toggle_active.php" class="inline">
									<?= csrf_field() ?>
									<input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
									<button class="btn btn-sm" data-confirm="<?= $r['aktywny'] ? 'Wyłączyć użytkownika?' : 'Włączyć użytkownika?' ?>">
									<?= $r['aktywny'] ? '🛑 Dezaktywuj' : '✅ Aktywuj' ?>
									</button>
								</form>
							<?php endif; ?>

							<?php if (hasAccess(['users.edit','users.admin'], false)): ?>
								<form method="post" action="/modules/administracja/uzytkownicy/reset_password.php" class="inline">
									<?= csrf_field() ?>
									<input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
									<button class="btn btn-sm" data-confirm="Zresetować hasło?">
										🔑 <?= __('global.reset') ?: 'Reset' ?>
									</button>
								</form>
							<?php endif; ?>

							<?php if (hasAccess(['users.delete','users.admin'], false)): ?>
								<form method="post" action="/modules/administracja/uzytkownicy/delete.php" class="inline">
									<?= csrf_field() ?>
									<input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
									<button class="btn btn-sm" data-confirm="Na pewno usunąć?">
										🗑️ <?= __('global.usun') ?: 'Usuń' ?>
									</button>
								</form>
							<?php endif; ?>
							</td>
						</tr>
				  <?php endforeach; ?>
				  </tbody>
			</table>
		</div>

		<?php if ($pages > 1): ?>
			<div class="page-actions" style="margin-top:12px;">
				<?php for ($i=1; $i<=$pages; $i++): ?>
					<a class="btn <?= $i===$page?'btn-primary':'' ?>" href="?<?= http_build_query(['q'=>$q,'active'=>$onlyActive,'pp'=>$perPage,'p'=>$i]) ?>"><?= $i ?></a>
				<?php endfor; ?>
			</div>
		<?php endif; ?>

		</div>
	</div>
</main>

<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
