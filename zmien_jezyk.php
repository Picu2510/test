<?php
session_start();
$allowed = ['pl', 'en', 'cz', 'ua'];

if (isset($_POST['lang']) && in_array($_POST['lang'], $allowed)) {
    $_SESSION['lang'] = $_POST['lang'];
}

// Wróć na poprzednią stronę
header('Location: ' . $_SERVER['HTTP_REFERER']);
exit;
