<?php
declare(strict_types=1);
require_once __DIR__.'/includes/init.php';

/** @var PDO $pdo */
$pdo = pdo();
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$db = $pdo->query('SELECT DATABASE()')->fetchColumn();

$tables = $pdo->query("
    SELECT TABLE_NAME, ENGINE, TABLE_COLLATION, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
    ORDER BY TABLE_NAME
")->fetchAll(PDO::FETCH_ASSOC);

$pk = $pdo->query("
    SELECT k.TABLE_NAME, k.COLUMN_NAME, k.ORDINAL_POSITION
    FROM information_schema.KEY_COLUMN_USAGE k
    JOIN information_schema.TABLE_CONSTRAINTS c
      ON c.CONSTRAINT_NAME = k.CONSTRAINT_NAME
     AND c.TABLE_SCHEMA = k.TABLE_SCHEMA
     AND c.TABLE_NAME = k.TABLE_NAME
    WHERE c.CONSTRAINT_TYPE='PRIMARY KEY'
      AND k.TABLE_SCHEMA = DATABASE()
    ORDER BY k.TABLE_NAME, k.ORDINAL_POSITION
")->fetchAll(PDO::FETCH_ASSOC);

$uniq = $pdo->query("
    SELECT tc.TABLE_NAME, tc.CONSTRAINT_NAME
    FROM information_schema.TABLE_CONSTRAINTS tc
    WHERE tc.TABLE_SCHEMA = DATABASE()
      AND tc.CONSTRAINT_TYPE='UNIQUE'
    ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_NAME
")->fetchAll(PDO::FETCH_ASSOC);

$idx = $pdo->query("
    SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE, GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLS
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
    GROUP BY TABLE_NAME, INDEX_NAME, NON_UNIQUE
    ORDER BY TABLE_NAME, INDEX_NAME
")->fetchAll(PDO::FETCH_ASSOC);

$fks = $pdo->query("
    SELECT
      kcu.TABLE_NAME, kcu.COLUMN_NAME, kcu.REFERENCED_TABLE_NAME, kcu.REFERENCED_COLUMN_NAME,
      rc.UPDATE_RULE, rc.DELETE_RULE, kcu.CONSTRAINT_NAME
    FROM information_schema.KEY_COLUMN_USAGE kcu
    JOIN information_schema.REFERENTIAL_CONSTRAINTS rc
      ON rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
     AND rc.CONSTRAINT_SCHEMA = kcu.CONSTRAINT_SCHEMA
    WHERE kcu.TABLE_SCHEMA = DATABASE()
      AND kcu.REFERENCED_TABLE_NAME IS NOT NULL
    ORDER BY kcu.TABLE_NAME, kcu.CONSTRAINT_NAME
")->fetchAll(PDO::FETCH_ASSOC);

$collations = $pdo->query("
    SELECT TABLE_NAME, TABLE_COLLATION
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
")->fetchAll(PDO::FETCH_KEY_PAIR);

$issues = [];

// Proste reguły jakości
$tablesByName = array_column($tables, null, 'TABLE_NAME');
$pkByTable = [];
foreach ($pk as $row) $pkByTable[$row['TABLE_NAME']][] = $row['COLUMN_NAME'];

// 1) Brak PK
foreach ($tablesByName as $t => $info) {
    if (empty($pkByTable[$t])) $issues[] = "Tabela `$t` nie ma PRIMARY KEY.";
}

// 2) Collation mix
$collSet = array_unique(array_values($collations));
if (count($collSet) > 1) {
    $issues[] = "Wykryto różne collation w tabelach: ".implode(', ', $collSet);
}

// 3) Indeksy dla FK
$fkByTable = [];
foreach ($fks as $fk) {
    $fkByTable[$fk['TABLE_NAME']][] = $fk['COLUMN_NAME'];
}
foreach ($fkByTable as $t => $cols) {
    $idxCols = array_filter($idx, fn($i) => $i['TABLE_NAME']===$t);
    $idxColsStr = implode(' | ', array_map(fn($i)=>$i['COLS'], $idxCols));
    foreach ($cols as $c) {
        if (!preg_match('/\b'.preg_quote($c, '/').'\b/', $idxColsStr)) {
            $issues[] = "Tabela `$t` ma FK na kolumnie `$c` bez indeksu — dodaj INDEX ($c).";
        }
    }
}

// 4) Silnik
foreach ($tables as $t) {
    if (($t['ENGINE'] ?? '') !== 'InnoDB') {
        $issues[] = "Tabela `{$t['TABLE_NAME']}` nie jest InnoDB (jest {$t['ENGINE']}).";
    }
}

$out = [
    'scanned_at' => date('c'),
    'database' => $db,
    'tables' => $tables,
    'primary_keys' => $pk,
    'unique_constraints' => $uniq,
    'indexes' => $idx,
    'foreign_keys' => $fks,
    'issues' => $issues,
];

header('Content-Type: text/html; charset=utf-8');
echo "<h1>Raport bazy danych: {$db}</h1>";
echo "<pre>".htmlspecialchars(json_encode($out, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE))."</pre>";
