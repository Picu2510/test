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

requireLogin();
requirePermission(['users.permissions','users.edit','users.*','admin.*','*']);
if ($_SERVER['REQUEST_METHOD'] === 'POST') csrf_verify($_POST['csrf'] ?? null);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  exit('POST only');
}

csrf_verify($_POST['csrf'] ?? null);

/** @var PDO $pdo */
$pdo = pdo(); // <-- BEZ TEGO $pdo JEST null

$uid = (int)($_POST['user_id'] ?? 0);
if ($uid <= 0) { http_response_code(400); exit('Bad user'); }

// Flagi modułów
$access_cmms         = isset($_POST['access_cmms']) ? 1 : 0;
$access_mes          = isset($_POST['access_mes']) ? 1 : 0;
$access_kompetencje  = isset($_POST['access_kompetencje']) ? 1 : 0;

// Role (multi)
// Jest (single):
$roleId = (int)($_POST['role_id'] ?? 0);

// Nadpisania uprawnień: perm_override[pid] => allow|deny|inherit
$permOverride = (array)($_POST['perm_override'] ?? []);

try {
  $pdo->beginTransaction();

  // 1) Flagi w users
  $stmt = $pdo->prepare("
    UPDATE users
       SET access_cmms = ?, access_mes = ?, access_kompetencje = ?, updated_at = NOW()
     WHERE id = ?
  ");
  $stmt->execute([$access_cmms, $access_mes, $access_kompetencje, $uid]);

  // 2) Role użytkownika
	$pdo->prepare("DELETE FROM users_role WHERE user_id = ?")->execute([$uid]);
	if ($roleId > 0) {
	  $pdo->prepare("INSERT INTO users_role (user_id, role_id) VALUES (?, ?)")->execute([$uid, $roleId]);
	}

  // 3) Nadpisania uprawnień
  $pdo->prepare("DELETE FROM users_user_permission WHERE user_id = ?")->execute([$uid]);
  if (!empty($permOverride)) {
    $insPerm = $pdo->prepare("INSERT INTO users_user_permission (user_id, permission_id, `allow`) VALUES (?, ?, ?)");
    foreach ($permOverride as $pid => $state) {
      $pid = (int)$pid;
      if ($pid <= 0) continue;
      if ($state === 'allow') { $insPerm->execute([$uid, $pid, 1]); }
      elseif ($state === 'deny') { $insPerm->execute([$uid, $pid, 0]); }
      // inherit -> pomijamy (dziedziczenie z roli)
    }
  }

  $pdo->commit();
	safe_redirect('/modules/administracja/uzytkownicy/list.php');
  //header('Location: ' . ROOT_URL . 'modules/administracja/uzytkownicy/edit_permissions.php?id=' . $uid . '&saved=1');
  exit;

} catch (Throwable $e) {
  if ($pdo && $pdo->inTransaction()) $pdo->rollBack();
  // tu możesz zalogować błąd do swojego loggera
  http_response_code(500);
  exit('Błąd zapisu: ' . $e->getMessage());
}