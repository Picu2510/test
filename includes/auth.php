<?php
declare(strict_types=1);

function start_session(): void {
  $app = require ROOT_PATH . 'config/app.php';
  session_name($app['session_name'] ?? 'CMMSSESSID');

  // Parametry ciasteczka sesji (PHP 8.2+)
  $secure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off');
  session_set_cookie_params([
    'lifetime' => 0,
    'path' => '/',
    'domain' => '',             // zostaw puste (aktualna domena)
    'secure' => $secure,        // true na HTTPS
    'httponly' => true,
    'samesite' => 'Lax',        // 'Strict' jeśli nie osadzamy i nie wysyłamy w cross-site
  ]);

  if (session_status() === PHP_SESSION_NONE) {
    session_start();
  }
}

function requireLogin(): void {
  if (empty($_SESSION['user']['id']) && empty($_SESSION['user_id'])) {
    header('Location: /login.php'); exit;
  }
}

/** Zwraca zalogowanego użytkownika z sesji (skrót). */
function currentUser(): ?array {
  return $_SESSION['user'] ?? null;
}

function loadUserPermissions(PDO $pdo, int $userId): array {
    // 1) uprawnienia wynikające z ról
    $sqlRolesPerms = "
        SELECT p.key
        FROM users_role ur
        JOIN users_role_permission rp ON rp.role_id = ur.role_id
        JOIN users_permission p ON p.id = rp.permission_id
        WHERE ur.user_id = :uid
    ";

    // 2) nadpisania per użytkownik (allow/deny)
    $sqlUserPerms = "
        SELECT p.key, up.allow
        FROM users_user_permission up
        JOIN users_permission p ON p.id = up.permission_id
        WHERE up.user_id = :uid
    ";

    $stmt = $pdo->prepare($sqlRolesPerms);
    $stmt->execute([':uid' => $userId]);
    $fromRoles = array_column($stmt->fetchAll(PDO::FETCH_ASSOC), 'key');

    $stmt = $pdo->prepare($sqlUserPerms);
    $stmt->execute([':uid' => $userId]);
    $overrides = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Składanie: deny > allow > rola
    $granted = array_fill_keys($fromRoles, true);
    foreach ($overrides as $row) {
        if ((int)$row['allow'] === 1)  $granted[$row['key']] = true;
        if ((int)$row['allow'] === 0)  unset($granted[$row['key']]); // twarde DENY
    }

    // Flagi modułów z tabeli `users` (szybkie filtry do UI)
    // @note: użyj swojego mechanizmu pobrania aktualnego usera
    $stmt = $pdo->prepare("SELECT access_cmms, access_mes, access_kompetencje FROM users WHERE id = :uid");
    $stmt->execute([':uid' => $userId]);
    $flags = $stmt->fetch(PDO::FETCH_ASSOC) ?: ['access_cmms'=>0,'access_mes'=>0,'access_kompetencje'=>0];

    return [
        'perms' => array_keys($granted),             // lista stringów
        'flags' => array_map('intval', $flags),      // szybkie modułowe
        'loaded_at' => time()
    ];
}
