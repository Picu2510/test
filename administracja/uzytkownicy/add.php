<?php
//  modules/administracja/uzytkownicy/add.php
// add.php

declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';

if (!function_exists('safe_redirect')) {
  function safe_redirect(string $url): void {
    if (!headers_sent()) { header('Location: '.$url); exit; }
    echo '<meta http-equiv="refresh" content="0;url='.htmlspecialchars($url, ENT_QUOTES).'">';
    echo '<script>location.replace('.json_encode($url).');</script>'; exit;
  }
}

requireLogin();
checkAccess(['users.edit','users.admin'], false);

$pageTitle    = __('users.add.tytul', 'Dodaj użytkownika');
$activeModule = 'admin';

/** @var PDO $pdo */
$pdo = pdo();
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$err = '';

/** helper do „lepienia” wartości z POST */
function old(string $key, $default = '') {
  return $_SERVER['REQUEST_METHOD'] === 'POST'
    ? ($_POST[$key] ?? $default)
    : $default;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_verify($_POST['csrf'] ?? null);

  $login  = trim((string)($_POST['login'] ?? ''));
  $imie   = trim((string)($_POST['imie'] ?? ''));
  $nazw   = trim((string)($_POST['nazwisko'] ?? ''));
  $email  = trim((string)($_POST['email'] ?? ''));
  $lang   = trim((string)($_POST['language'] ?? 'pl'));
  $pin    = trim((string)($_POST['pin'] ?? ''));
  $roleId = (int)($_POST['role_id'] ?? 0);
  $active = isset($_POST['aktywny']) ? 1 : 0;

  $pass1  = (string)($_POST['password'] ?? '');
  $pass2  = (string)($_POST['password_confirm'] ?? '');

  // walidacja
  if ($login === '' || $imie === '' || $nazw === '') {
    $err = __('users.add.err_brak_podstawowych', 'Uzupełnij login, imię i nazwisko.');
  } elseif ($pass1 === '' || $pass1 !== $pass2) {
    $err = __('users.add.err_hasla', 'Hasła są puste lub niezgodne.');
  } elseif ($pin !== '' && !preg_match('/^\d{6}$/', $pin)) {
    $err = __('users.add.err_pin', 'PIN musi mieć 6 cyfr (lub zostaw pusty).');
  }

  // pre-check unikalności (prosty i bez złożonych placeholderów)
  if ($err === '') {
    if ($pin !== '') {
      $pre = $pdo->prepare("SELECT 1 FROM users WHERE login = :login OR pin = :pin LIMIT 1");
      $pre->execute([':login' => $login, ':pin' => $pin]);
    } else {
      $pre = $pdo->prepare("SELECT 1 FROM users WHERE login = :login LIMIT 1");
      $pre->execute([':login' => $login]);
    }
    if ($pre->fetchColumn()) {
      $err = __('users.add.err_duplikat', 'Login lub PIN już istnieje.');
    }
  }

  if ($err === '') {
    try {
      $hash = password_hash($pass1, PASSWORD_DEFAULT);

      $stmt = $pdo->prepare(
        "INSERT INTO users
           (login, haslo, pin, imie, nazwisko, email, language, role_id, aktywny, created_at)
         VALUES
           (:login, :haslo, :pin, :imie, :nazwisko, :email, :lang, :role_id, :aktywny, NOW())"
      );
      $stmt->execute([
        ':login'    => $login,
        ':haslo'    => $hash,
        ':pin'      => ($pin !== '' ? $pin : null),
        ':imie'     => $imie,
        ':nazwisko' => $nazw,
        ':email'    => ($email !== '' ? $email : null),
        ':lang'     => $lang,
        ':role_id'  => ($roleId ?: null),
        ':aktywny'  => $active,
      ]);

      // SUKCES
      safe_redirect('/modules/administracja/uzytkownicy/list.php');
      exit;
    } catch (PDOException $e) {
      // Detekcja duplikatu
      $sqlState   = $e->errorInfo[0] ?? null;     // '23000'
      $driverCode = (int)($e->errorInfo[1] ?? 0); // 1062
      $msg        = (string)($e->errorInfo[2] ?? $e->getMessage());

      if ($sqlState === '23000' && $driverCode === 1062) {
        // Spróbuj wywnioskować po tekście komunikatu, który unikalny klucz zadziałał
        if (stripos($msg, 'login') !== false) {
          $err = __('users.add.err_login_duplikat', 'Login już istnieje.');
        } elseif (stripos($msg, 'pin') !== false) {
          $err = __('users.add.err_pin_duplikat', 'PIN już istnieje.');
        } else {
          $err = __('users.add.err_duplikat', 'Login lub PIN już istnieje.');
        }
      } else {
        $err = __('users.add.err_db', 'Błąd zapisu: ').$e->getMessage();
      }

      // Zapisz pełny komunikat do logu serwera – pomoże, jeśli problemem jest np. UNIQUE na "haslo"
      error_log('users/add insert error: '.$msg);
    }
  }
}

// role do selecta
$roles = $pdo->query("SELECT id, name FROM roles ORDER BY name")->fetchAll(PDO::FETCH_ASSOC);

// języki
$supportedLangs = (require ROOT_PATH.'config/i18n.php')['supported'] ?? ['pl'];

include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>
<main class="content page-narrow">
	<header class="page-header">
		<nav class="breadcrumb">
	
		</nav>
	</header>  
  
	<div class="card">
		<?php if ($err): ?><div class="status danger"><?= htmlspecialchars($err) ?></div><?php endif; ?>

		<form method="post" class="form-grid form-grid--1col" autocomplete="off" novalidate>
			<?= csrf_field() ?>

			<div class="field">
				<label><?= __('users.add.login') ?: 'Login' ?></label>
				<input type="text" name="login" required value="<?= htmlspecialchars((string)old('login')) ?>">
			</div>

			<div class="field">
				<label><?= __('users.add.email') ?: 'E-mail' ?></label>
				<input type="email" name="email" value="<?= htmlspecialchars((string)old('email')) ?>">
			</div>

			<div class="field">
				<label><?= __('users.add.imie') ?: 'Imię' ?></label>
				<input type="text" name="imie" required value="<?= htmlspecialchars((string)old('imie')) ?>">
			</div>

			<div class="field">
				<label><?= __('users.add.nazwisko') ?: 'Nazwisko' ?></label>
				<input type="text" name="nazwisko" required value="<?= htmlspecialchars((string)old('nazwisko')) ?>">
			</div>

			<div class="field">
			<label><?= __('users.add.jezyk') ?: 'Język' ?></label>
				<select name="language">
					<?php $currentLang = (string)old('language', 'pl'); ?>
					<?php foreach ($supportedLangs as $code): ?>
						<option value="<?= $code ?>" <?= $currentLang === $code ? 'selected' : '' ?>><?= strtoupper($code) ?></option>
					<?php endforeach; ?>
				</select>
			</div>

			<div class="field">
				<label><?= __('users.add.rola') ?: 'Rola' ?></label>
				<select name="role_id">
				<option value=""><?= __('global.brak') ?: '—' ?></option>
				<?php $currentRole = (int)old('role_id', 0); ?>
				<?php foreach ($roles as $r): $rid = (int)$r['id']; ?>
					<option value="<?= $rid ?>" <?= $currentRole === $rid ? 'selected' : '' ?>>
					<?= htmlspecialchars($r['name']) ?>
				</option>
				<?php endforeach; ?>
				</select>
			</div>

			<div class="field">
				<label><?= __('users.add.pin') ?: 'PIN (opcjonalny, 6 cyfr)' ?></label>
				<div class="pin-row">
				<input type="text" name="pin" id="pin" pattern="\d{6}" maxlength="6" placeholder="••••••" value="<?= htmlspecialchars((string)old('pin')) ?>">
				<button type="button" class="btn btn-secondary btn-sm pin-gen-btn" data-url="/actions/generate_pin.php"> 🎲 <?= __('users.add.generujPin') ?: 'Generuj PIN' ?></button>
			</div>
			<small class="muted"><?= __('users.add.tylkoDlaAdministratorów') ?: 'Tylko dla administratorów.' ?></small>
			</div>

			<div class="field">
				<label><?= __('users.add.haslo') ?: 'Hasło' ?></label>
				<input type="password" name="password" required>
			</div>

			<div class="field">
				<label><?= __('users.add.powtorzHaslo') ?: 'Powtórz hasło' ?></label>
				<input type="password" name="password_confirm" required>
			</div>

			<label class="checkbox">
				<?php $activeOld = ($_SERVER['REQUEST_METHOD'] === 'POST') ? isset($_POST['aktywny']) : true; ?>
				<input type="checkbox" id="aktywny" name="aktywny" value="1" <?= !empty($row['active']) ? 'checked' : '' ?>>
				<span><?= __('cmms.common.active','Aktywna') ?></span>
			</label>		  

			<div class="form-actions">
				<button class="btn btn-primary"><?= __('global.zapisz') ?: 'Zapisz' ?></button>
				<a class="btn" href="/modules/administracja/uzytkownicy/list.php"><?= __('global.anuluj') ?: 'Anuluj' ?></a>
			</div>
		</form>
	</div>
</main>
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
