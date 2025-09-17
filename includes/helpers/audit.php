<?php
declare(strict_types=1);

function audit_log(PDO $pdo, string $table, $recordId, string $action, ?array $before, ?array $after): void {
  $uid = (int)(currentUser()['id'] ?? 0) ?: null;

  $maxLen = 20000;
  $beforeJson = $before ? json_encode($before, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) : null;
  $afterJson  = $after  ? json_encode($after,  JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) : null;
  if ($beforeJson && strlen($beforeJson) > $maxLen) $beforeJson = substr($beforeJson, 0, $maxLen);
  if ($afterJson  && strlen($afterJson)  > $maxLen) $afterJson  = substr($afterJson,  0, $maxLen);

  $st = $pdo->prepare("
    INSERT INTO audit_log (user_id, table_name, record_id, action, before_json, after_json, ip, user_agent, route)
    VALUES (:uid, :tbl, :rid, :act, :b, :a, :ip, :ua, :rt)
  ");
  $st->execute([
    ':uid'=>$uid,
    ':tbl'=>$table,
    ':rid'=>$recordId,
    ':act'=>$action,
    ':b'=>$beforeJson,
    ':a'=>$afterJson,
    ':ip'=>($_SERVER['REMOTE_ADDR'] ?? null),
    ':ua'=>($_SERVER['HTTP_USER_AGENT'] ?? null),
    ':rt'=>($_SERVER['REQUEST_URI'] ?? null),
  ]);
}
