<?php
declare(strict_types=1);

$__pdo = null;
/** @return PDO */
function pdo(): PDO {
  global $__pdo;
  if ($__pdo instanceof PDO) return $__pdo;
  $cfg = require ROOT_PATH . 'config/database.php';
  try {
    $__pdo = new PDO($cfg['dsn'], $cfg['user'], $cfg['pass'], $cfg['options']);
    // opcjonalnie: ustaw strefę czasową po stronie MySQL
    $__pdo->exec("SET time_zone = '+02:00'");
    return $__pdo;
  } catch (PDOException $e) {
    // log do /includes/logs/errors.log
    if (function_exists('log_error')) {
      log_error('DB connection failed', ['msg'=>$e->getMessage()]);
    }
    http_response_code(500);
    exit('Błąd połączenia z bazą danych. Sprawdź konfigurację DB w .env');
  }
}
