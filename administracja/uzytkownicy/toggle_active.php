<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

if (!function_exists('safe_redirect')) {
  function safe_redirect(string $url): void {
    if (!headers_sent()) { header('Location: '.$url); exit; }
    echo '<meta http-equiv="refresh" content="0;url='.htmlspecialchars($url, ENT_QUOTES).'">';
    echo '<script>location.replace('.json_encode($url).');</script>'; exit;
  }
}

requireLogin(); checkAccess(['users.edit','users.admin'], false);
csrf_verify($_POST['csrf'] ?? null);

$id = (int)($_POST['id'] ?? 0);
$pdo = pdo();
$pdo->prepare("UPDATE users SET aktywny = 1 - aktywny, updated_at=NOW() WHERE id=?")->execute([$id]);

safe_redirect('/modules/administracja/uzytkownicy/list.php');
