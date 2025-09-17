<?php
declare(strict_types=1);
require_once __DIR__ . '/../../../includes/init.php';

header('Content-Type: application/json; charset=utf-8');

echo json_encode([
  'session_status' => session_status(),     // 2 = ACTIVE
  'session_id'     => session_id(),
  'has_cookie'     => isset($_COOKIE[session_name()]),
  'user_id'        => $_SESSION['user_id'] ?? null,
  'perms_count'    => count($_SESSION['authz']['perms'] ?? []),
  'sample_perms'   => array_slice($_SESSION['authz']['perms'] ?? [], 0, 15),
  'can' => [
    'users.edit' => can('users.edit'),
    'users.*'    => can('users.*'),
    'admin.*'    => can('admin.*'),
    '*'          => can('*'),
  ],
], JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE);
