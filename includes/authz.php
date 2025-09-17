<?php
declare(strict_types=1);

/** Czy użytkownik jest „globalnym adminem”. */
function isAdmin(): bool {
  $u = currentUser();
  if (!$u) return false;

  $perms = $u['perms'] ?? [];
  if (in_array('*', $perms, true)) return true;

  $roleName = strtolower((string)($u['role_name'] ?? ''));
  return $roleName === 'admin';
}

/**
 * Sprawdza dostęp (nie przerywa wykonania). Obsługuje:
 * - string: 'cmms.view'
 * - tablicę: ['cmms.view','kompetencje.view'] – wtedy ALL = true (wszystkie), ALL = false (którykolwiek)
 * - wildcard '*'
 * - modułowy admin: 'cmms.admin' daje dostęp do wszystkich 'cmms.*'
 */
function hasAccess(string|array $perm, bool $all = true): bool {
  $u = currentUser();
  if (!$u) return false;

  $perms = $u['perms'] ?? [];
  if (empty($perms)) return isAdmin(); // admin przejdzie

  // Globalny admin ma wszystko
  if (in_array('*', $perms, true) || isAdmin()) return true;

  // Funkcja do pojedynczego klucza
  $checkOne = function (string $key) use ($perms): bool {
    if (in_array($key, $perms, true)) return true;
    // modułowy admin: 'cmms.*'
    $parts = explode('.', $key, 2);
    if (!empty($parts[0]) && in_array($parts[0].'.admin', $perms, true)) return true;
    return false;
  };

  if (is_string($perm)) {
    return $checkOne($perm);
  }

  // Tablica uprawnień
  $results = array_map($checkOne, $perm);
  return $all ? !in_array(false, $results, true) : in_array(true, $results, true);
}

/** Twarde wymuszenie dostępu do zasobu. Rzuca 403 albo przerzuca na login. */
// wiele uprawnień: ANY/ALL
function checkAccess(array|string $perms, bool $requireAll = false): bool {
    $list = is_array($perms) ? $perms : [$perms];
    if ($requireAll) {
        foreach ($list as $p) if (!can($p)) return false;
        return true;
    }
    foreach ($list as $p) if (can($p)) return true;
    return false;
}

/** Wymaga co najmniej jednego z podanych uprawnień. */
function requireAny(array $perms): void { checkAccess($perms, false); }

/** Wymaga wszystkich podanych uprawnień. */
function requireAll(array $perms): void { checkAccess($perms, true); }

function currentPerms(): array {
    return $_SESSION['authz']['perms'] ?? [];
}

function moduleFlags(): array {
    return $_SESSION['authz']['flags'] ?? ['access_cmms'=>0,'access_mes'=>0,'access_kompetencje'=>0];
}

// Zwróć listę przyznanych (po DENY>ALLOW już rozstrzygnięte w loadUserPermissions)
function user_perms(): array {
    return $_SESSION['authz']['perms'] ?? [];
}


/** Sprawdza uprawnienie z obsługą wildcardów końcowych: a.b.c → a.b.c | a.b.* | a.* */
// pojedynczy check z obsługą '*.':
function can(string $want): bool {
    $perms = user_perms();
    if (!$perms) return false;

    foreach ($perms as $g) {
        if ($g === $want) return true;
        // wildcard: 'users.*' obejmuje 'users.edit' itd.
        if (substr($g, -2) === '.*') {
            $prefix = substr($g, 0, -1); // zostaje 'users.'
            if (strncmp($want, $prefix, strlen($prefix)) === 0) return true;
        }
        // globalny wildcard (jeśli używasz): '*'
        if ($g === '*') return true;
    }
    return false;
}



function any(array $permissions): bool {
    foreach ($permissions as $p) if (can($p)) return true;
    return false;
}

// twarde egzekwowanie
function requirePermission(array|string $perms, bool $requireAll = false): void {
    if (!checkAccess($perms, $requireAll)) {
        http_response_code(403);
        exit('Forbidden');
    }
}

function requireModuleFlag(string $flag): void {
    $flags = moduleFlags();
    if (empty($flags[$flag])) {
        http_response_code(403);
        $path = defined('ROOT_PATH') ? ROOT_PATH . 'errors/403.php' : null;
        if ($path && is_file($path)) {
            include $path;
        } else {
            echo '403 Forbidden';
        }
        exit;
    }
}

/** (opcjonalnie) odśwież sesję z uprawnieniami po zmianach profilu */
function refreshAuthz(PDO $pdo): void {
    if (!empty($_SESSION['user_id']) && function_exists('loadUserPermissions')) {
        $_SESSION['authz'] = loadUserPermissions($pdo, (int)$_SESSION['user_id']);
    }
}

function ensureAuthzLoaded(PDO $pdo): void {
  $uid = (int)($_SESSION['user']['id'] ?? $_SESSION['user_id'] ?? 0);
  if ($uid > 0 && empty($_SESSION['authz']['perms'])) {
    $_SESSION['authz'] = loadUserPermissions($pdo, $uid);
  }
}