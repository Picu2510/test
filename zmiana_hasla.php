<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/init.php';

$pageTitle    = __('password.title') ?: 'Zmiana hasła';
$activeModule = ''; // bez sidebara

$pdo  = pdo();
$err  = '';
$ok   = false;

// Czy user zalogowany?
$me = $_SESSION['user'] ?? null;
$force = !empty($_GET['force']) || !empty($_SESSION['force_pw_change']);

// prosta polityka haseł (dopasuj do siebie)
function validate_password_policy(string $pwd, ?string &$msg = null): bool {
    // przykładowo: min 10 znaków, min 1 litera, 1 cyfra; brak spacji
    $ok = (strlen($pwd) >= 10)
       && preg_match('/[A-Za-z]/', $pwd)
       && preg_match('/\d/', $pwd)
       && !preg_match('/\s/', $pwd);
    if (!$ok) {
        $msg = 'Hasło musi mieć min. 10 znaków, zawierać literę i cyfrę oraz nie zawierać spacji.';
    }
    return $ok;
}

// pomocniczo: znajdź usera po loginie lub "Nazwisko Imię"
function find_user_by_identifier(PDO $pdo, string $identifier): ?array {
    // najpierw spróbuj login
    $stmt = $pdo->prepare("SELECT * FROM users WHERE login = ? AND aktywny = 1 LIMIT 1");
    $stmt->execute([$identifier]);
    $u = $stmt->fetch();
    if ($u) return $u;

    // spróbuj "Nazwisko Imię"
    $parts = preg_split('~\s+~', trim($identifier));
    if (count($parts) >= 2) {
        $nazwisko = $parts[0];
        $imie     = $parts[1];
        $stmt = $pdo->prepare("SELECT * FROM users WHERE nazwisko = ? AND imie = ? AND aktywny = 1 LIMIT 1");
        $stmt->execute([$nazwisko, $imie]);
        $u = $stmt->fetch();
        if ($u) return $u;
    }
    return null;
}

// POST: zapis
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verify($_POST['csrf'] ?? null);

    $identifier = trim($_POST['identifier'] ?? '');
    $current    = (string)($_POST['current_password'] ?? '');
    $new1       = (string)($_POST['new_password'] ?? '');
    $new2       = (string)($_POST['new_password_confirm'] ?? '');

    // Kogo zmieniamy: zalogowany czy wg identyfikatora?
    if ($me) {
        $user = $pdo->prepare("SELECT * FROM users WHERE id = ? AND aktywny = 1");
        $user->execute([(int)$me['id']]);
        $user = $user->fetch();
    } else {
        if ($identifier === '') {
            $err = 'Podaj login lub "Nazwisko Imię".';
        } else {
            $user = find_user_by_identifier($pdo, $identifier);
        }
    }

    if (!$err) {
        if (!$user) {
            $err = 'Nie znaleziono użytkownika lub konto jest nieaktywne.';
        } elseif ($current === '' || !password_verify($current, $user['haslo'])) {
            $err = 'Obecne hasło jest nieprawidłowe.';
        } elseif ($new1 === '' || $new2 === '' || $new1 !== $new2) {
            $err = 'Nowe hasła są puste lub niezgodne.';
        } elseif (!validate_password_policy($new1, $msg)) {
            $err = $msg;
        } else {
            // OK – zapis nowego hasła
            $hash = password_hash($new1, PASSWORD_DEFAULT);
            $upd  = $pdo->prepare("UPDATE users SET haslo = ?, updated_at = NOW() WHERE id = ?");
            $upd->execute([$hash, (int)$user['id']]);

            // Jeżeli wymuszaliśmy zmianę – zdejmij flagę
            unset($_SESSION['force_pw_change']);

            $ok = true;
            // jeśli user był zalogowany – wyloguj i przenieś do loginu
            // (opcjonalne – odświeża sesję)
            if ($me) {
                $_SESSION = [];
                if (ini_get('session.use_cookies')) {
                    $p = session_get_cookie_params();
                    setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
                }
                session_destroy();
            }

            // Komunikat i redirect na login
			flash_set('success', 'Hasło zostało zmienione. Zaloguj się nowym hasłem.');
			header('Location: /login.php'); 
            exit;
        }
    }
}

// Widok
?>
<!DOCTYPE html>
<html lang="<?= htmlspecialchars($_SESSION['lang'] ?? current_locale()) ?>">
<head>
  <meta charset="utf-8">
  <title><?= htmlspecialchars($pageTitle) ?></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body class="login-page">
  <div class="auth-wrap">
    <div class="auth-card">
      <h1 class="auth-title"><?= htmlspecialchars($pageTitle) ?></h1>

      <?php if ($force): ?>
        <div class="auth-alert" role="alert">Ze względów bezpieczeństwa prosimy o ustawienie nowego hasła.</div>
      <?php endif; ?>

      <?php if ($err): ?>
        <div class="auth-alert" role="alert"><?= htmlspecialchars($err) ?></div>
      <?php endif; ?>

      <form method="post" class="auth-form">
        <?= csrf_field() ?>

        <?php if (!$me): ?>
          <label for="identifier" class="auth-label">Login lub „Nazwisko Imię”</label>
          <div class="input-wrap">
            <span class="input-ico">👤</span>
            <input type="text" id="identifier" name="identifier" placeholder="np. kowalski.j lub Kowalski Jan" required>
          </div>
        <?php endif; ?>

        <label for="current_password" class="auth-label">Obecne hasło</label>
        <div class="input-wrap">
          <span class="input-ico">🔒</span>
          <input type="password" id="current_password" name="current_password" required>
        </div>

        <label for="new_password" class="auth-label">Nowe hasło</label>
        <div class="input-wrap">
          <span class="input-ico">🗝️</span>
          <input type="password" id="new_password" name="new_password" required>
        </div>

        <label for="new_password_confirm" class="auth-label">Powtórz nowe hasło</label>
        <div class="input-wrap">
          <span class="input-ico">🗝️</span>
          <input type="password" id="new_password_confirm" name="new_password_confirm" required>
        </div>

        <button type="submit" class="btn btn-primary btn-lg">Zapisz nowe hasło</button>

        <div class="auth-footer" style="margin-top:10px;">
          <a href="/login.php">⬅️ Wróć do logowania</a>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
