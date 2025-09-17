<?php
declare(strict_types=1);

function env(string $key, ?string $default=null): ?string {
  static $vars = null;
  if ($vars === null) {
    $vars = [];
    foreach (['/env/.env.local','/env/.env'] as $file) {
      $path = __DIR__ . '/..' . $file;
      if (is_readable($path)) {
        foreach (file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
          if (str_starts_with(trim($line), '#')) continue;
          [$k, $v] = array_pad(explode('=', $line, 2), 2, null);
          if ($k) $vars[trim($k)] = $v !== null ? trim($v) : '';
        }
      }
    }
  }
  return $vars[$key] ?? $default;
}
