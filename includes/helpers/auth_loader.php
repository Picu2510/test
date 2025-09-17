<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';

/** Zwraca listę kluczy uprawnień dla użytkownika (rola + nadpisania + kolumny access_*) */
function fetchUserPermissions(int $userId): array {
    $pdo = pdo();

    // 1) Rola użytkownika
    $user = $pdo->prepare("SELECT id, role_id, access_cmms, access_mes, access_kompetencje, access_szkolenia, imie, nazwisko, email, login
                           FROM users WHERE id = ?");
    $user->execute([$userId]);
    $u = $user->fetch();
    if (!$u) return [];

    $perms = [];

    // 2) Permisy z roli
    if (!empty($u['role_id'])) {
        $rp = $pdo->prepare("SELECT perm_key FROM role_permissions WHERE role_id = ?");
        $rp->execute([$u['role_id']]);
        $perms = array_column($rp->fetchAll(PDO::FETCH_ASSOC), 'perm_key');
    }

    // 3) Nadpisania per-user (opcjonalne)
    $up = $pdo->prepare("SELECT perm_key FROM user_permissions WHERE user_id = ?");
    $up->execute([$userId]);
    $perms = array_merge($perms, array_column($up->fetchAll(PDO::FETCH_ASSOC), 'perm_key'));

    // 4) Zgodność z istniejącymi kolumnami access_* (dodajemy *.view)
    if (!empty($u['access_cmms']))         $perms[] = 'cmms.view';
    if (!empty($u['access_mes']))          $perms[] = 'mes.view';
    if (!empty($u['access_kompetencje']))  $perms[] = 'kompetencje.view';
    if (!empty($u['access_szkolenia']))    $perms[] = 'szkolenia.view';

    // 5) Unikalizacja
    $perms = array_values(array_unique($perms));

    return $perms;
}

/** Ładuje pełny profil użytkownika do sesji wraz z uprawnieniami. */
function loadUserIntoSession(int $userId): void {
    $pdo = pdo();
    $stmt = $pdo->prepare("
	  SELECT u.id, u.imie, u.nazwisko, u.email, u.login, u.role_id,
				 r.name AS role_name,
				 u.access_cmms, u.access_mes, u.access_kompetencje, u.access_szkolenia
		  FROM users u
		  LEFT JOIN roles r ON r.id = u.role_id
		  WHERE u.id = ?
		");
    $stmt->execute([$userId]);
    $u = $stmt->fetch();
    if (!$u) return;



    $_SESSION['user'] = [
        'id'        => (int)$u['id'],
        'imie'      => $u['imie'] ?? '',
        'nazwisko'  => $u['nazwisko'] ?? '',
        'email'     => $u['email'] ?? '',
        'login'     => $u['login'] ?? '',
        'role_id'   => $u['role_id'] ? (int)$u['role_id'] : null,
		'role_name' => $u['role_name'] ?? null,
        'perms'     => fetchUserPermissions((int)$u['id']),
    ];
	$_SESSION['user_id'] = (int)$user['id'];                     // <<< DODAJ
	$_SESSION['authz']   = loadUserPermissions($pdo, (int)$user['id']);

}

/** Odśwież uprawnienia (np. po zmianie roli). */
function refreshSessionPerms(): void {
    if (!empty($_SESSION['user']['id'])) {
        $_SESSION['user']['perms'] = fetchUserPermissions((int)$_SESSION['user']['id']);
    }
}

