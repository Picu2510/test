<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/init.php';

// Zabezpieczenie przed CSRF – logout wywołujemy tylko POSTem
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: /dashboard.php');
    exit;
}

csrf_verify($_POST['csrf'] ?? null);

// Usuń wszystkie dane sesji
$_SESSION = [];
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}
session_destroy();

// Usuń ciasteczka dodatkowe (np. lang)
setcookie('lang', '', time() - 3600, '/');

// Redirect na stronę logowania
header('Location: /login.php');
exit;
