<?php
session_start();

require_once __DIR__ . '/app/includes/env.php';
require_once __DIR__ . '/app/includes/config.php';
require_once __DIR__ . '/app/includes/db.php';
require_once __DIR__ . '/app/includes/functions.php';

define('ROOT_PATH', dirname(__DIR__) . '/'); // ✅ to wskazuje na katalog główny

// Połączenie z bazą danych
$dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
$pdo = new PDO($dsn, DB_USER, DB_PASS, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
]);

// Obsługa wielojęzyczności
$defaultLanguage = 'pl';
$availableLanguages = ['pl', 'en', 'cz', 'ua'];
$currentLanguage = $_SESSION['lang'] ?? $defaultLanguage;

// Sprawdź czy plik istnieje
$langFile = __DIR__ . "/app/lang/$currentLanguage.php";
if (!in_array($currentLanguage, $availableLanguages) || !file_exists($langFile)) {
    $currentLanguage = $defaultLanguage;
    $langFile = __DIR__ . "/app/lang/$defaultLanguage.php";
}

$translations = require $langFile;

// Funkcja tłumacząca
if (!function_exists('__')) {
    function __($key) {
        global $translations;
        return $translations[$key] ?? $key;
    }
}
