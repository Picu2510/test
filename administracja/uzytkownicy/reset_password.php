<?php
declare(strict_types=1);

require_once __DIR__ . '/../../../includes/init.php';
requireLogin();
checkAccess(['users.admin','users.edit'], false);
csrf_verify($_POST['csrf'] ?? null);

$id = (int)($_POST['id'] ?? 0);
if ($id <= 0) { http_response_code(400); exit('Bad request'); }

$pdo = pdo();

// Wygeneruj mocne tymczasowe hasło (12 znaków alfanum.+spec)
function temp_password(int $len=12): string {
  $alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789!@#$%^&*';
  $out = '';
  for ($i=0; $i<$len; $i++) {
    $out .= $alphabet[random_int(0, strlen($alphabet)-1)];
  }
  return $out;
}

$tmp = 'start123'; temp_password(12);
$hash = password_hash($tmp, PASSWORD_DEFAULT);

$stm = $pdo->prepare("UPDATE users SET haslo=?, force_pw_change=1, updated_at=NOW() WHERE id=?");
$stm->execute([$hash, $id]);

// Pokaż adminowi flash z nowym hasłem (tylko jednorazowo na ekranie)
flash_set('info', 'Tymczasowe hasło: '.$tmp.' (użytkownik będzie musiał je zmienić przy następnym logowaniu)');
redirect('/modules/administracja/uzytkownicy/list.php');
