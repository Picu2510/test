<?php
declare(strict_types=1);

// 1) Bootstrap (sesja, config, DB, i18n, helpers)
require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

if (!function_exists('safe_redirect')) {
  function safe_redirect(string $url): void {
    if (!headers_sent()) { header('Location: '.$url); exit; }
    echo '<meta http-equiv="refresh" content="0;url='.htmlspecialchars($url, ENT_QUOTES).'">';
    echo '<script>location.replace('.json_encode($url).');</script>'; exit;
  }
}

// Jeżeli już zalogowany → dashboard
if (!empty($_SESSION['user']['id'])) {
    safe_redirect('/dashboard.php');
}

$error = '';
$mode  = $_POST['mode'] ?? 'password';

/** Znajdź użytkownika po identyfikatorze:
 *  - login
 *  - "nazwisko imię"
 *  - "imię nazwisko"
 */
function findUserByIdentifier(PDO $pdo, string $identifier): ?array {
    $identifier = trim($identifier);
    if ($identifier === '') return null;

    // Spróbuj dopasować login 1:1
    $sql = "SELECT id, login, haslo, imie, nazwisko, role_id, aktywny, language,
                   access_cmms, access_mes, access_kompetencje, access_szkolenia
            FROM users
            WHERE aktywny = 1 AND login = ?
            LIMIT 1";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$identifier]);
    $u = $stmt->fetch();
    if ($u) return $u;

    // Rozbij po białych znakach i spróbuj obie kolejności
    $parts = preg_split('/\s+/u', $identifier, -1, PREG_SPLIT_NO_EMPTY);
    if (count($parts) >= 2) {
        // Załóżmy ostatnie słowo to imię, reszta to nazwisko (np. "Kowalski Jan")
        $imie = array_pop($parts);
        $nazwisko = implode(' ', $parts);

        $sql2 = "SELECT id, login, haslo, imie, nazwisko, role_id, aktywny, language,
                        access_cmms, access_mes, access_kompetencje, access_szkolenia
                 FROM users
                 WHERE aktywny = 1
                   AND (
                     (LOWER(nazwisko)=LOWER(?) AND LOWER(imie)=LOWER(?))
                     OR
                     (LOWER(imie)=LOWER(?) AND LOWER(nazwisko)=LOWER(?))
                   )
                 LIMIT 1";
        $stmt2 = $pdo->prepare($sql2);
        $stmt2->execute([$nazwisko, $imie, $nazwisko, $imie]); // obie kolejności
        $u2 = $stmt2->fetch();
        if ($u2) return $u2;
    }
    return null;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pdo = pdo();

    if ($mode === 'password') {
        $username = trim($_POST['username'] ?? '');
        $password = (string)($_POST['password'] ?? '');

        if ($username !== '' && $password !== '') {
            $user = findUserByIdentifier($pdo, $username);

            if ($user && !empty($user['haslo']) && password_verify($password, $user['haslo'])) {
                // Załaduj pełen profil + uprawnienia do sesji
                loadUserIntoSession((int)$user['id']);
                // Ustaw język (jeśli kolumna istnieje)
                if (!empty($user['language'])) {
                    $_SESSION['lang'] = $user['language'];
                }

                // Wymuszenie zmiany hasła dla domyślnego startowego (opcjonalnie)
                if ($password === 'start123') {
                    safe_redirect('/zmiana_hasla.php?force=1');
                }
				
				if (!empty($user['force_pw_change'])) {
					$_SESSION['force_pw_change'] = true;
					header('Location: /zmiana_hasla.php?force=1');
					exit;
				}
                safe_redirect('/dashboard.php');
            } else {
                $error = __('login.invalid_credentials') ?: 'Nieprawidłowe dane logowania.';
            }
        } else {
            $error = __('login.fill_all_fields') ?: 'Uzupełnij wszystkie pola.';
        }

    } elseif ($mode === 'pin') {
        $pin = trim($_POST['pin'] ?? '');
		
        if (preg_match('/^\d{6}$/', $pin)) {
            $stmt = $pdo->prepare("SELECT id, login, imie, nazwisko, role_id, aktywny, language,
                                          access_cmms, access_mes, access_kompetencje, access_szkolenia
                                   FROM users
                                   WHERE pin = ? AND aktywny = 1
                                   LIMIT 1");
            $stmt->execute([$pin]);
            $user = $stmt->fetch();

            if ($user) {
                loadUserIntoSession((int)$user['id']);
                if (!empty($user['language'])) {
                    $_SESSION['lang'] = $user['language'];
                }
				
				if ($password === 'start123') {
					$_SESSION['force_pw_change'] = true;
					header('Location: /zmiana_hasla.php?force=1');
					exit;
				}
                safe_redirect('/dashboard.php');
            } else {
                $error = __('login.invalid_pin') ?: 'Nieprawidłowy PIN.';
            }
        } else {
            $error = __('login.fill_all_fields') ?: 'Uzupełnij wszystkie pola.';
        }
    }
}
?>


<!doctype html>
<html lang="<?= htmlspecialchars($_SESSION['lang'] ?? 'pl', ENT_QUOTES, 'UTF-8') ?>">
	<head>
		  <meta charset="utf-8">
		  <title><?= __('login.tytul') ?: 'Logowanie' ?></title>
		  <meta name="viewport" content="width=device-width, initial-scale=1">
		  <link rel="stylesheet" href="/assets/css/style.css">
		  <script defer src="/assets/js/main.js"></script>
	</head>

	<body class="login-page">
		  <div class="auth-wrap">
				<div class="auth-card">
					<?= flash_render() ?>
				  <h1 class="auth-title"><?= __('login.zalogujSie') ?: 'Zaloguj się' ?></h1>

				  <?php if (!empty($error)): ?>
					<div class="auth-alert" role="alert">
					  <?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?>
					</div>
				  <?php endif; ?>

				  <!-- Zakładki -->
				  <div class="auth-tabs" role="tablist" aria-label="Metoda logowania">
					<button type="button" class="auth-tab <?= $mode!=='pin'?'is-active':'' ?>" data-auth-tab="password" aria-selected="<?= $mode!=='pin'?'true':'false' ?>">
					  🔒 <?= __('login.haslo') ?: 'Hasło' ?>
					</button>
					<button type="button" class="auth-tab <?= $mode==='pin'?'is-active':'' ?>" data-auth-tab="pin" aria-selected="<?= $mode==='pin'?'true':'false' ?>">
					  📲 <?= __('login.pin') ?: 'PIN' ?>
					</button>
				  </div>

					  <!-- Formularz: login/hasło -->
					  <form method="post" id="auth-pass" class="auth-form <?= $mode==='pin'?'is-hidden':'' ?>">
					<?= csrf_field() ?>
						<input type="hidden" name="mode" value="password">
						<?= function_exists('csrf_field') ? csrf_field() : '' ?>

						<label for="username" class="auth-label"><?= __('login.login') ?: 'Login / Nazwisko Imię' ?></label>
						<div class="input-wrap">
						  <span class="input-ico">👤</span>
						  <input type="text" name="username" id="username" placeholder="np. kowalski.j / Kowalski Jan" required>
						</div>

						<label for="password" class="auth-label"><?= __('login.haslo') ?: 'Hasło' ?></label>
						<div class="input-wrap">
						  <span class="input-ico">🔑</span>
						  <input type="password" name="password" id="password" required>
						</div>

						<button type="submit" class="btn btn-primary btn-lg">
						  🔐 <?= __('login.zaloguj') ?: 'Zaloguj' ?>
						</button>
					  </form>

					  <!-- Formularz: PIN -->
					<form method="post" id="auth-pin" class="auth-form <?= $mode==='pin'?'':'is-hidden' ?>">
					<?= csrf_field() ?>
							<input type="hidden" name="mode" value="pin">
							<?= function_exists('csrf_field') ? csrf_field() : '' ?>

							<label for="pin" class="auth-label"><?= __('login.kodPin') ?: 'Kod PIN (6 cyfr)' ?></label>
							<div class="input-wrap">
								<span class="input-ico">#</span>
								<input type="text" name="pin" id="pin" inputmode="numeric" pattern="\d{6}" maxlength="6" placeholder="••••••" required>
							</div>

							<button type="submit" class="btn btn-primary btn-lg">
								📲 <?= __('login.zalogujPinem') ?: 'Zaloguj PIN-em' ?>
							</button>
					  </form>

					  <div class="auth-footer">
							<a href="/zmiana_hasla.php">🔑 <?= __('login.zmienHaslo') ?: 'Zmień hasło' ?></a>
					  </div>
				</div>
		  </div>
	</body>
</html>


  <script>
    function toggleMode(mode) {
      document.getElementById('form-pass').style.display = (mode === 'password') ? 'block' : 'none';
      document.getElementById('form-pin').style.display  = (mode === 'pin') ? 'block' : 'none';
    }
  </script>