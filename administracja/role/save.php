<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

requireLogin();
requirePermission(['roles.manage','roles.edit','roles.*','admin.*','*']);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit; }
csrf_verify($_POST['csrf'] ?? null);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit('POST only'); }
csrf_verify($_POST['csrf'] ?? null);

$pdo = pdo();

$id   = (int)($_POST['id']   ?? 0);
$name = trim((string)($_POST['name'] ?? ''));
$perm = array_values(array_unique(array_map('intval', (array)($_POST['perm'] ?? []))));
if ($name === '') { http_response_code(400); exit('Brak nazwy'); }

try {
  $pdo->beginTransaction();

  if ($id) {
    // nie blokujemy edycji nazwy dla systemowych, ale możesz dodać warunek
    $stmt = $pdo->prepare("UPDATE roles SET name = ?, updated_at = NOW() WHERE id = ?");
    $stmt->execute([$name, $id]);
  } else {
    $stmt = $pdo->prepare("INSERT INTO roles (name, is_system, created_at) VALUES (?, 0, NOW())");
    $stmt->execute([$name]);
    $id = (int)$pdo->lastInsertId();
  }

  // mapowanie uprawnień
  $pdo->prepare("DELETE FROM users_role_permission WHERE role_id = ?")->execute([$id]);
  if ($perm) {
    $ins = $pdo->prepare("INSERT INTO users_role_permission (role_id, permission_id) VALUES (?, ?)");
    foreach ($perm as $pid) {
      if ($pid > 0) $ins->execute([$id, $pid]);
    }
  }

  $pdo->commit();
  safe_redirect('/modules/administracja/role/list.php');
  //header('Location: '.ROOT_URL.'modules/administracja/role/edit.php?id='.$id.'&saved=1');
  exit;

} catch (Throwable $e) {
  if ($pdo->inTransaction()) $pdo->rollBack();
  http_response_code(500);
  exit('Błąd zapisu: '.$e->getMessage());
}
