<?php
declare(strict_types=1);
require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';
requireLogin();

if (!empty($_GET['return'])) {
    $ret = (string)$_GET['return'];
    $u   = parse_url($ret);
    $path = $u['path'] ?? '';
    $qs   = isset($u['query']) ? ('?'.$u['query']) : '';

    // tylko bezpieczne, wewnętrzne ścieżki
    if (str_starts_with($path, '/modules/cmms/zgloszenia/show_light.php')) {
        header('Location: ' . rtrim(ROOT_URL,'/') . $path . $qs, true, 302);
        exit;
    }
}

$ret = $_GET['return'] ?? '/dashboard.php';
?>

<?php include ROOT_PATH.'includes/layout/header.php'; ?>
<main class="content content--light">
  <div class="card">
    <h1>CMMS – tryb LIGHT</h1>
    <p>Szybkie akcje:</p>
    <div class="grid grid--2">
		<?php if (checkAccess(['cmms.tickets.create','cmms.*','admin.*'])): ?>
		  <a class="btn btn-primary btn-lg"
			 href="/modules/cmms/zgloszenia/edit.php?return=<?= urlencode('/light/index.php') ?>">
			 ➕ <?= __('cmms.ticket.new','Nowe zgłoszenie') ?>
		  </a>
		<?php endif; ?>
		
	`	<?php if (checkAccess(['cmms.tickets.create','cmms.*','admin.*'])): ?>
		  <a class="btn" href="/light/tickets_my.php">📝 Moje zgłoszenia</a>
		<?php endif; ?>
      <a class="btn" href="<?= h($ret) ?>">Wróć do pełnej wersji</a>
    </div>
	
  </div>

  <div class="card">
    <h2>Moje ostatnie zgłoszenia</h2>
    <?php include __DIR__.'/partials/my_recent_tickets.php'; ?>
  </div>
</main>
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
