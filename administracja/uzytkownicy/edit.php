<?php
// modules/administracja/uzytkownicy/edit.php
// Jeden widok do dodawania i edycji użytkownika

declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'].'/includes/init.php';


/* ---------- auth / perms ---------- */
requireLogin();
requirePermission(['users.edit','users.admin']);
$activeModule = 'admin';
$pageTitle    = __('uzytkownicy.edit.tytul') ?: 'Edycja użytkownika';

/* ---------- helpers ---------- */
if (!function_exists('safe_redirect')) {
  function safe_redirect(string $url): void {
    if (!headers_sent()) { header('Location: '.$url); exit; }
    $urlEsc = htmlspecialchars($url, ENT_QUOTES);
    echo '<meta http-equiv="refresh" content="0;url='.$urlEsc.'">';
    echo '<script>location.replace('.json_encode($url).');</script>'; exit;
  }
}

/** Old helper: wypełnia pola danymi z POST lub z domyślnej tablicy ($row) */
function old(string $key, $default = '', ?array $row = null) {
  if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    return $_POST[$key] ?? $default;
  }
  if ($row !== null && array_key_exists($key, $row)) {
    return $row[$key];
  }
  return $default;
}

/* ---------- db ---------- */
$pdo = pdo();
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

/* ---------- tryb ---------- */
$id   = (int)($_GET['id'] ?? $_POST['id'] ?? 0);
$mode = $id > 0 ? 'edit' : 'add';
if ($mode === 'add') {
  $pageTitle = __('uzytkownicy.add.tytul', 'Dodaj użytkownika');
}

/* ---------- wczytaj rekord przy edycji ---------- */
$editUser = null;
if ($mode === 'edit') {
  $stmt = $pdo->prepare("
    SELECT id, login, imie, nazwisko, email, language, pin, role_id, aktywny
    FROM users WHERE id = ?
  ");
  $stmt->execute([$id]);
  $editUser = $stmt->fetch(PDO::FETCH_ASSOC);
  if (!$editUser) { http_response_code(404); exit('User not found'); }
}

/* ---------- role / języki ---------- */
$roles = $pdo->query("SELECT id, name FROM roles ORDER BY name")->fetchAll(PDO::FETCH_ASSOC);
$supportedLangs = (require ROOT_PATH.'config/i18n.php')['supported'] ?? ['pl'];

/* ---------- obsługa POST ---------- */
$err = '';
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

  /* --- walidacja ogólna --- */
  if ($login === '' || $imie === '' || $nazw === '') {
    $err = __('uzytkownicy.add.err_brak_podstawowych', 'Uzupełnij login, imię i nazwisko.');
  } elseif ($pin !== '' && !preg_match('/^\d{6}$/', $pin)) {
    $err = __('uzytkownicy.add.err_pin', 'PIN musi mieć 6 cyfr (lub zostaw pusty).');
  }

  /* --- walidacja haseł --- */
  if ($err === '') {
    if ($mode === 'add') {
      if ($pass1 === '' || $pass1 !== $pass2) {
        $err = __('uzytkownicy.add.err_hasla', 'Hasła są puste lub niezgodne.');
      }
    } else { // edit
      if ($pass1 !== '' && $pass1 !== $pass2) {
        $err = __('uzytkownicy.edit.err_hasla', 'Hasła nie są zgodne.');
      }
    }
  }

  /* --- unikalność login/pin --- */
  if ($err === '') {
    if ($pin !== '') {
      $sql = "SELECT 1 FROM users WHERE (login = :login OR pin = :pin) ".($mode==='edit'?'AND id <> :id ':'')."LIMIT 1";
      $pre = $pdo->prepare($sql);
      $pre->execute([
        ':login' => $login,
        ':pin'   => $pin,
        ...($mode==='edit' ? [':id'=>$id] : []),
      ]);
    } else {
      $sql = "SELECT 1 FROM users WHERE login = :login ".($mode==='edit'?'AND id <> :id ':'')."LIMIT 1";
      $pre = $pdo->prepare($sql);
      $pre->execute([
        ':login' => $login,
        ...($mode==='edit' ? [':id'=>$id] : []),
      ]);
    }
    if ($pre->fetchColumn()) {
      $err = __('uzytkownicy.add.err_duplikat', 'Login lub PIN już istnieje.');
    }
  }

  /* --- zapis --- */
  if ($err === '') {
    try {
      if ($mode === 'add') {
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
      } else {
        // przygotuj pola
        $fields = [
          'login'    => $login,
          'imie'     => $imie,
          'nazwisko' => $nazw,
          'email'    => ($email !== '' ? $email : null),
          'language' => $lang,
          'pin'      => ($pin !== '' ? $pin : null),
          'role_id'  => ($roleId ?: null),
          'aktywny'  => $active,
        ];
        if ($pass1 !== '') {
          $fields['haslo'] = password_hash($pass1, PASSWORD_DEFAULT);
        }

        $sets = [];
        $args = [];
        foreach ($fields as $col => $val) {
          $sets[] = "$col = ?";
          $args[] = $val;
        }
        $sets[] = "updated_at = NOW()";
        $args[] = $id;

        $sql = "UPDATE users SET ".implode(', ', $sets)." WHERE id = ?";
        $upd = $pdo->prepare($sql);
        $upd->execute($args);
      }

      safe_redirect('/modules/administracja/uzytkownicy/list.php');
    } catch (PDOException $e) {
      $sqlState   = $e->errorInfo[0] ?? null;
      $driverCode = (int)($e->errorInfo[1] ?? 0);
      $msg        = (string)($e->errorInfo[2] ?? $e->getMessage());

      if ($sqlState === '23000' && $driverCode === 1062) {
        if (stripos($msg, 'login') !== false)      { $err = __('uzytkownicy.add.err_login_duplikat', 'Login już istnieje.'); }
        elseif (stripos($msg, 'pin') !== false)    { $err = __('uzytkownicy.add.err_pin_duplikat', 'PIN już istnieje.'); }
        else                                       { $err = __('uzytkownicy.add.err_duplikat', 'Login lub PIN już istnieje.'); }
      } else {
        $err = __('uzytkownicy.add.err_db', 'Błąd zapisu: ').$e->getMessage();
      }
      error_log('users/edit save error: '.$msg);
    }
  }

  // przy błędzie nadpisz $editUser wartościami z POST (żeby nie tracić wpisów)
  if ($mode === 'edit' && $err) {
    $editUser = array_merge($editUser, [
      'login'    => $login,
      'imie'     => $imie,
      'nazwisko' => $nazw,
      'email'    => ($email !== '' ? $email : null),
      'language' => $lang,
      'pin'      => ($pin !== '' ? $pin : null),
      'role_id'  => ($roleId ?: null),
      'aktywny'  => $active,
    ]);
  }
}

/* ---------- widok ---------- */
include ROOT_PATH.'includes/layout/header.php';
include ROOT_PATH.'includes/layout/sidebar.php';
?>
<main class="content page-narrow">
	<header class="page-header">
		<nav class="breadcrumb"></nav>
	</header>

	<div class="card">
		<?php if ($err): ?>
			<div class="status danger"><?= htmlspecialchars($err) ?></div>
		<?php endif; ?>

		<form method="post" class="form-grid form-edit" autocomplete="off" novalidate>
			<?= csrf_field() ?>
			<?php if ($mode === 'edit'): ?>
				<input type="hidden" name="id" value="<?= (int)$editUser['id'] ?>">
			<?php endif; ?>

			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.login') ?: 'Login' ?></label>
				<input type="text" name="login" required value="<?= htmlspecialchars((string)old('login', '', $editUser)) ?>">
			</div>

			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.email') ?: 'E-mail' ?></label>
				<input type="email" name="email" value="<?= htmlspecialchars((string)old('email', '', $editUser)) ?>">
			</div>

			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.imie') ?: 'Imię' ?></label>
				<input type="text" name="imie" required value="<?= htmlspecialchars((string)old('imie', '', $editUser)) ?>">
			</div>

			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.nazwisko') ?: 'Nazwisko' ?></label>
				<input type="text" name="nazwisko" required value="<?= htmlspecialchars((string)old('nazwisko', '', $editUser)) ?>">
			</div>

			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.jezyk') ?: 'Język' ?></label>
				<select name="language">
					<?php $currentLang = (string)old('language', $mode==='edit' ? ($editUser['language'] ?? 'pl') : 'pl'); ?>
					<?php foreach ($supportedLangs as $code): ?>
					<option value="<?= $code ?>" <?= $currentLang === $code ? 'selected' : '' ?>>
						<?= strtoupper($code) ?>
					</option>
					<?php endforeach; ?>
				</select>
			</div>

			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.rola') ?: 'Rola' ?></label>
				<?php $currentRole = (int)old('role_id', $mode==='edit' ? (int)($editUser['role_id'] ?? 0) : 0); ?>
				<select name="role_id">
					<option value="">
						<?= __('global.brak') ?: '—' ?>
					</option>
					<?php foreach ($roles as $r): $rid = (int)$r['id']; ?>
					<option value="<?= $rid ?>" <?= $currentRole === $rid ? 'selected' : '' ?>>
						<?= htmlspecialchars($r['name']) ?>
					</option>
					<?php endforeach; ?>
				</select>
			</div>

			<div class="field">
				<label class="field__label">
					<?= __('uzytkownicy.add.pin') ?: 'PIN (opcjonalny, 6 cyfr)' ?>
				</label>
				<div class="pin-row inline">
					<input type="text" name="pin" id="pin" pattern="\d{6}" maxlength="6" placeholder="••••••" value="<?= htmlspecialchars((string)old('pin', $mode==='edit' ? (string)($editUser['pin'] ?? '') : '')) ?>">
					<button type="button" class="btn btn-secondary btn-sm pin-gen-btn" data-url="/actions/generate_pin.php">
						🎲 <?= __('uzytkownicy.add.generujPin') ?: 'Generuj PIN' ?>
					</button>
				</div>
				<small class="muted">
					<?= __('uzytkownicy.add.tylkoDlaAdministratorow') ?: 'Tylko dla administratorów.' ?>
				</small>
			</div>

			<?php if ($mode === 'add'): ?>
			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.haslo') ?: 'Hasło' ?></label>
				<input type="password" name="password" required>
			</div>
			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.powtorzHaslo') ?: 'Powtórz hasło' ?></label>
				<input type="password" name="password_confirm" required>
			</div>
			<?php else: ?>
			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.edit.noweHaslo') ?: 'Nowe hasło (opcjonalnie)' ?></label>
				<input type="password" name="password" placeholder="<?= __('uzytkownicy.edit.pozostawPusteZebyNieZmieniac') ?: 'pozostaw puste, aby nie zmieniać' ?>">
			</div>
			<div class="field">
				<label class="field__label"><?= __('uzytkownicy.add.powtorzHaslo') ?: 'Powtórz nowe hasło' ?></label>
				<input type="password" name="password_confirm" placeholder="<?= __('uzytkownicy.add.jakWyzej') ?: 'jak wyżej' ?>">
			</div>
			<?php endif; ?>

			<label class="checkbox">
			<?php $checked = ($_SERVER['REQUEST_METHOD'] === 'POST') ? isset($_POST['aktywny']) : ($mode === 'edit' ? !empty($editUser['aktywny']) : true); ?>
				<input type="checkbox" id="aktywny" name="aktywny" value="1" <?= $checked ? 'checked' : '' ?>>
				<span class="label-strong"><?= __('uzytkownicy.add.aktywny') ?: 'Aktywny' ?></span>
			</label>

			<div class="form-actions">
				<button class="btn btn-primary">
					<?= __('global.zapisz') ?: 'Zapisz' ?>
				</button>
				<a class="btn" href="/modules/administracja/uzytkownicy/list.php">
					<?= __('global.anuluj') ?: 'Anuluj' ?>
				</a>
			</div>
		</form>
	</div>
</main>
<?php include ROOT_PATH.'includes/layout/footer.php'; ?>
