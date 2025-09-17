<?php
declare(strict_types=1);
require_once __DIR__ . '/../../../../includes/init.php';

requireLogin();
requirePermission(['roles.manage','roles.delete','roles.*','admin.*','*']);
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit; }
csrf_verify($_POST['csrf'] ?? null);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit('POST only'); }
csrf_verify($_POST['csrf'] ?? null);

/** @var PDO $pdo */
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

$id  = (int)($_POST['id'] ?? 0);
if ($id <= 0) { http_response_code(400); exit('Bad id'); }

// blokada ról systemowych
$sys = $pdo->prepare("SELECT is_system FROM roles WHERE id = ?");
$sys->execute([$id]);
$flag = (int)($sys->fetchColumn() ?: 0);
if ($flag === 1) { http_response_code(403); exit('Nie można usunąć roli systemowej'); }

try {
  $pdo->beginTransaction();
  $pdo->prepare("DELETE FROM users_role_permission WHERE role_id = ?")->execute([$id]);
  $pdo->prepare("DELETE FROM users_role            WHERE role_id = ?")->execute([$id]);
  $pdo->prepare("DELETE FROM roles                 WHERE id = ?")->execute([$id]);
  $pdo->commit();
  
  
  redirect('/modules/administracja/role/list.php');
  //header('Location: '.ROOT_URL.'modules/administracja/role/list.php?deleted=1');
  exit;
} catch (Throwable $e) {
  if ($pdo->inTransaction()) $pdo->rollBack();
  http_response_code(500);
  exit('Błąd usuwania: '.$e->getMessage());
}
