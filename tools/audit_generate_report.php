<?php
// tools/audit_generate_report.php
declare(strict_types=1);

/**
 * Generator raportu audytowego – CMMS/MES (PHP 8.1+)
 * - Nie modyfikuje bazy ani plików; tylko czyta i zapisuje raporty do /tools/audit-report/
 * - Próbuje użyć istniejącego pdo() z includes/init.php jeśli jest dostępny
 */

error_reporting(E_ALL);
ini_set('display_errors', '1');

$ROOT = realpath(__DIR__ . '/..');
$OUT  = __DIR__ . '/audit-report';
@mkdir($OUT, 0775, true);

function out(string $name, string $content): void {
    global $OUT;
    file_put_contents("$OUT/$name", $content);
    echo "✔ $name (" . strlen($content) . " B)\n";
}

function allFiles(string $root, string $regex): array {
    $rii = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator($root, FilesystemIterator::SKIP_DOTS)
    );
    $out = [];
    foreach ($rii as $f) {
        $p = str_replace('\\', '/', $f->getPathname());
        if (preg_match($regex, $p) && !str_contains($p, '/vendor/')) $out[] = $p;
    }
    sort($out);
    return $out;
}

function phpTokens(string $file): array {
    $src = @file_get_contents($file) ?: '';
    $tokens = token_get_all($src);
    $funcs = []; $classes = [];
    for ($i=0,$n=count($tokens); $i<$n; $i++) {
        $t = $tokens[$i];
        if (is_array($t) && $t[0] === T_FUNCTION) {
            $j = $i+1;
            while ($j<$n && (!is_array($tokens[$j]) || $tokens[$j][0]!==T_STRING)) $j++;
            if ($j<$n) $funcs[] = strtolower($tokens[$j][1]);
        }
        if (is_array($t) && in_array($t[0], [T_CLASS, T_INTERFACE, T_TRAIT], true)) {
            $j = $i+1;
            while ($j<$n && (!is_array($tokens[$j]) || $tokens[$j][0]!==T_STRING)) $j++;
            if ($j<$n) $classes[] = $tokens[$j][1];
        }
    }
    return [$funcs, $classes];
}

function grepRefs(array $phpFiles): array {
    $refs = [];
    foreach ($phpFiles as $f) {
        $src = @file_get_contents($f) ?: '';

        // require/include
        preg_match_all('~\b(require|include)(_once)?\s*\(?\s*[\'"]([^\'"]+)~i', $src, $m, PREG_SET_ORDER);
        foreach ($m as $mm) $refs[$f]['inc'][] = $mm[3];

        // href/src/action links do .php/.js/.css
        preg_match_all('~\b(href|src|action)\s*=\s*[\'"]([^\'"]+)[\'"]~i', $src, $m2, PREG_SET_ORDER);
        foreach ($m2 as $mm2) if (preg_match('~\.(php|js|css)$~i', $mm2[2])) $refs[$f]['link'][] = $mm2[2];

        // inline
        if (preg_match('~<style[^>]*>~i', $src)) $refs[$f]['inline_style'] = true;
        if (preg_match('~<script[^>]*>~i', $src) && !preg_match('~<script[^>]*src=~i', $src)) $refs[$f]['inline_script'] = true;

        // i18n: __() bez fallbacku (drugi parametr)
        preg_match_all('~__\(\s*([^\),]+)\s*\)~', $src, $m3, PREG_SET_ORDER);
        foreach ($m3 as $mm3) $refs[$f]['i18n_no_fallback'][] = trim($mm3[1]);

        // literówka modules/cmmms/
        if (strpos($src, 'modules/cmmms/') !== false) $refs[$f]['typo_cmmms'] = true;
    }
    return $refs;
}

function toWeb(string $abs, string $root): string {
    $web = str_replace($root, '', $abs);
    return str_replace('\\','/', $web);
}

/* 1) Skan plików */
$phpFiles = allFiles($ROOT, '~\.php$~i');
$jsFiles  = allFiles($ROOT, '~\.js$~i');
$cssFiles = allFiles($ROOT, '~\.css$~i');

/* 2) Duplikaty funkcji/klas */
$fnMap=[]; $clsMap=[];
foreach ($phpFiles as $f) {
    [$fns, $clss] = phpTokens($f);
    foreach ($fns as $n)   $fnMap[$n][] = $f;
    foreach ($clss as $cn) $clsMap[$cn][] = $f;
}
$dupeFn = array_filter($fnMap, fn($arr)=>count(array_unique($arr))>1);
$dupeCl = array_filter($clsMap, fn($arr)=>count(array_unique($arr))>1);

$buf = [];
foreach ($dupeFn as $name=>$arr) {
    $buf[] = $name."\n  - ".implode("\n  - ", array_unique(array_map(fn($p)=>toWeb($p,$ROOT), $arr)));
}
out('duplicates_functions.txt', implode("\n", $buf));

$buf = [];
foreach ($dupeCl as $name=>$arr) {
    $buf[] = $name."\n  - ".implode("\n  - ", array_unique(array_map(fn($p)=>toWeb($p,$ROOT), $arr)));
}
out('duplicates_classes.txt', implode("\n", $buf));

/* 3) Referencje (unused + inline + i18n + typos) */
$refs = grepRefs($phpFiles);
$referenced = [];
foreach ($refs as $src=>$info) {
    foreach (['inc','link'] as $k) {
        foreach (($info[$k] ?? []) as $r) {
            if (preg_match('~^https?://~', $r)) continue;
            $referenced['/'.ltrim($r,'/')] = true;
        }
    }
}

$unusedPhp = [];
foreach ($phpFiles as $f) {
    $web = toWeb($f, $ROOT);
    if (!isset($referenced[$web]) && !str_contains($web, '/includes/')) $unusedPhp[] = $web;
}
out('unused_php.txt', implode("\n", $unusedPhp));

$assets = array_merge($jsFiles, $cssFiles);
$refAssets = [];
foreach ($refs as $info) {
    foreach (($info['link'] ?? []) as $r) {
        if (preg_match('~\.(css|js)$~i', $r)) $refAssets['/'.ltrim($r,'/')] = true;
    }
}
$unusedAssets = [];
foreach ($assets as $a) {
    $web = toWeb($a, $ROOT);
    if (!isset($refAssets[$web])) $unusedAssets[] = $web;
}
out('unused_assets.txt', implode("\n", $unusedAssets));

$typos = [];
$inline = [];
$i18nNoFallback = [];
foreach ($refs as $f=>$info) {
    $web = toWeb($f, $ROOT);
    if (!empty($info['typo_cmmms'])) $typos[] = $web;
    if (!empty($info['inline_style']) || !empty($info['inline_script'])) $inline[] = $web;
    foreach (array_unique($info['i18n_no_fallback'] ?? []) as $call) {
        $i18nNoFallback[] = "$web :: __($call)";
    }
}
out('typos_cmmms.txt', implode("\n", array_unique($typos)));
out('inline_csp.txt', implode("\n", array_unique($inline)));
out('i18n_no_fallback.txt', implode("\n", array_unique($i18nNoFallback)));

/* 4) Baza danych – użycie tabel vs. rzeczywista baza */
$pdo = null;
try {
    // Spróbuj wciągnąć pdo() z projektu (jeśli istnieje)
    $initPath = $ROOT . '/includes/init.php';
    if (is_file($initPath)) {
        require_once $initPath;
        if (function_exists('pdo')) { $pdo = pdo(); $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); }
    }
} catch (Throwable $e) {
    // brak połączenia – przejdź dalej, zrobimy audyt bez DB
}

$allTables = [];
if ($pdo instanceof PDO) {
    try {
        $schema = $pdo->query('SELECT DATABASE()')->fetchColumn() ?: '';
        $st = $pdo->prepare("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE()");
        $st->execute();
        $allTables = array_map(fn($r)=>$r['TABLE_NAME'], $st->fetchAll(PDO::FETCH_ASSOC));
        sort($allTables);
    } catch (Throwable $e) {
        // pomiń
    }
}

// heurystyczne wyciągnięcie nazw tabel z kodu (PDO->query/prepare, SQL w stringach)
$tablesInCode = [];
$rx = '~\bFROM\s+`?([a-zA-Z0-9_]+)`?|\bJOIN\s+`?([a-zA-Z0-9_]+)`?|\bINSERT\s+INTO\s+`?([a-zA-Z0-9_]+)`?|\bUPDATE\s+`?([a-zA-Z0-9_]+)`?|\bDELETE\s+FROM\s+`?([a-zA-Z0-9_]+)`?~i';
foreach ($phpFiles as $f) {
    $src = @file_get_contents($f) ?: '';
    if (preg_match_all($rx, $src, $m, PREG_SET_ORDER)) {
        foreach ($m as $mm) {
            foreach (array_slice($mm,1) as $g) if ($g) $tablesInCode[strtolower($g)] = true;
        }
    }
}
$tablesInCode = array_keys($tablesInCode);
sort($tablesInCode);

if ($allTables) {
    $unused = array_values(array_diff(array_map('strtolower',$allTables), array_map('strtolower',$tablesInCode)));
    out('db_unused_tables.txt', implode("\n", $unused));

    // Brak indeksów pod FK
    $missingIdxTxt = '';
    try {
        $sql = "
        SELECT k.TABLE_NAME, k.COLUMN_NAME, k.REFERENCED_TABLE_NAME, k.REFERENCED_COLUMN_NAME
        FROM information_schema.KEY_COLUMN_USAGE k
        LEFT JOIN information_schema.STATISTICS s
          ON s.TABLE_SCHEMA = k.TABLE_SCHEMA
         AND s.TABLE_NAME   = k.TABLE_NAME
         AND s.COLUMN_NAME  = k.COLUMN_NAME
        WHERE k.TABLE_SCHEMA = DATABASE()
          AND k.REFERENCED_TABLE_NAME IS NOT NULL
          AND s.COLUMN_NAME IS NULL
        ORDER BY k.TABLE_NAME, k.COLUMN_NAME";
        $missing = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
        foreach ($missing as $row) {
            $missingIdxTxt .= sprintf(
                "%s.%s -> %s.%s (brak indeksu)\n",
                $row['TABLE_NAME'], $row['COLUMN_NAME'], $row['REFERENCED_TABLE_NAME'], $row['REFERENCED_COLUMN_NAME']
            );
        }
    } catch (Throwable $e) { /* ignore */ }
    out('db_missing_fk_indexes.txt', $missingIdxTxt);

    // Kolacje różne od utf8mb4_%
    $collTxt = '';
    try {
        $rows = $pdo->query("SELECT TABLE_NAME, TABLE_COLLATION FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE()")->fetchAll(PDO::FETCH_ASSOC);
        foreach ($rows as $r) {
            if (stripos((string)$r['TABLE_COLLATION'], 'utf8mb4_') !== 0) {
                $collTxt .= $r['TABLE_NAME'] . ' :: ' . $r['TABLE_COLLATION'] . "\n";
            }
        }
    } catch (Throwable $e) { /* ignore */ }
    out('db_collation_mismatch.txt', $collTxt);
} else {
    out('db_unused_tables.txt', "Brak połączenia z DB – nie sprawdzono.");
    out('db_missing_fk_indexes.txt', "Brak połączenia z DB – nie sprawdzono.");
    out('db_collation_mismatch.txt', "Brak połączenia z DB – nie sprawdzono.");
}

echo "\nRaport zapisany w: $OUT\n";
