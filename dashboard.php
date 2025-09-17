<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/init.php';
requireLogin(); // ⬅️ ważne

$pageTitle = 'Dashboard';
$activeModule = 'dashboard';
include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>




<!-- Twoja treść dashboardu -->
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
