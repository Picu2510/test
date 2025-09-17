<?php
// includes/files.php
declare(strict_types=1);

/** Zwraca względną (web) ścieżkę katalogu uploadów i tworzy go, np. /uploads/2025/09/structure/456/ */
function files_ensure_upload_dir(string $entityType, int $entityId): string {
    $entityType = preg_replace('/[^a-z0-9_\-]/i', '', $entityType);
    if ($entityId <= 0 || $entityType === '') {
        throw new InvalidArgumentException('Bad entity.');
    }
    $y = date('Y'); $m = date('m');
    $rel = "/uploads/{$y}/{$m}/{$entityType}/{$entityId}/";
    $abs = rtrim(ROOT_PATH, '/').$rel;
    if (!is_dir($abs) && !mkdir($abs, 0775, true) && !is_dir($abs)) {
        throw new RuntimeException('Cannot create upload dir.');
    }
    return $rel;
}

/** Prosta biała lista MIME/ext (rozszerzaj wg potrzeb) */
function files_validate_mime_and_ext(string $filename, string $mime): void {
    $allowedExt = ['jpg','jpeg','png','webp','gif','pdf','doc','docx','xls','xlsx','csv','txt'];
    $allowedMime = [
        'image/jpeg','image/png','image/webp','image/gif',
        'application/pdf',
        'application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'text/plain','text/csv','application/octet-stream'
    ];
    $ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
    if (!in_array($ext, $allowedExt, true)) {
        throw new RuntimeException('Nieobsługiwane rozszerzenie.');
    }
    if (!in_array($mime, $allowedMime, true)) {
        // część przeglądarek podaje octet-stream — zostawiamy wyjątek tylko gdy to ewidentnie coś innego
        if ($mime !== 'application/octet-stream') {
            throw new RuntimeException('Nieobsługiwany typ MIME.');
        }
    }
}

/** Generuje bezpieczną nazwę (bez kropki w tokenie) */
function files_safe_name(string $original): string {
    $ext  = strtolower((string)pathinfo($original, PATHINFO_EXTENSION));
    $base = (string)pathinfo($original, PATHINFO_FILENAME);

    if (function_exists('transliterator_transliterate')) {
        $base = transliterator_transliterate('Any-Latin; Latin-ASCII; [:Nonspacing Mark:] Remove; Lower()', $base);
    } else {
        $tmp  = @iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $base);
        $base = strtolower($tmp !== false ? $tmp : $base);
    }

    $base = preg_replace('/[^a-z0-9]+/i', '-', $base);
    $base = trim((string)$base, '-_');
    if ($base === '') $base = 'plik';

    $token = bin2hex(random_bytes(6)); // 12 znaków hex, bez kropki
    return $base . '-' . $token . ($ext ? '.' . $ext : '');
}

/** Czy tabela istnieje w aktywnej bazie */
function files_table_exists(PDO $pdo, string $table): bool {
    $st = $pdo->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = :t");
    $st->execute([':t' => $table]);
    return (int)$st->fetchColumn() > 0;
}

/** Prosty log diagnostyczny do /uploads/_files_debug.log */
function files_debug_log(string $msg): void {
    $log = rtrim(ROOT_PATH, '/') . '/uploads/_files_debug.log';
    @file_put_contents($log, date('c') . ' ' . $msg . PHP_EOL, FILE_APPEND);
}


/** Liczy sha1 z pliku (dla ewentualnej deduplikacji) */
function files_sha1(string $absPath): string {
    return sha1_file($absPath) ?: '';
}

/** Zapis rekordu pliku w DB; zwraca id */

function files_store(PDO $pdo, array $meta): int {
    $sql = "INSERT INTO cmms_plik
      (entity_type, entity_id, typ_id, nazwa_pliku, mime, rozmiar_b, sciezka, checksum_sha1, is_public, is_main, sort_order, uwagi, uploaded_by, created_at)
      VALUES (:entity_type,:entity_id,:typ_id,:nazwa_pliku,:mime,:rozmiar_b,:sciezka,:checksum_sha1,:is_public,:is_main,:sort_order,:uwagi,:uploaded_by, NOW())";

    $st = $pdo->prepare($sql);

    // WYMAGANE
    $st->bindValue(':entity_type', (string)$meta['entity_type'], PDO::PARAM_STR);   // 'ticket' | 'structure'
    $st->bindValue(':entity_id',   (int)$meta['entity_id'],      PDO::PARAM_INT);

    // OPCJONALNE / NULL-safe
    if (array_key_exists('typ_id',$meta) && $meta['typ_id'] !== null) {
        $st->bindValue(':typ_id', (int)$meta['typ_id'], PDO::PARAM_INT);
    } else {
        $st->bindValue(':typ_id', null, PDO::PARAM_NULL);
    }

    $st->bindValue(':nazwa_pliku',   (string)$meta['nazwa_pliku'],   PDO::PARAM_STR);
    $st->bindValue(':mime',          (string)$meta['mime'],          PDO::PARAM_STR);
    $st->bindValue(':rozmiar_b',     (int)$meta['rozmiar_b'],        PDO::PARAM_INT);
    $st->bindValue(':sciezka',       (string)$meta['sciezka'],       PDO::PARAM_STR);
    $st->bindValue(':checksum_sha1', (string)($meta['checksum_sha1'] ?? ''), PDO::PARAM_STR);
    $st->bindValue(':is_public',     (int)($meta['is_public'] ?? 0), PDO::PARAM_INT);
    $st->bindValue(':is_main',       (int)($meta['is_main'] ?? 0),   PDO::PARAM_INT);
    $st->bindValue(':sort_order',    (int)($meta['sort_order'] ?? 0),PDO::PARAM_INT);
    $st->bindValue(':uwagi',         (string)($meta['uwagi'] ?? ''), PDO::PARAM_STR);

    if (array_key_exists('uploaded_by',$meta) && $meta['uploaded_by'] !== null) {
        $st->bindValue(':uploaded_by', (int)$meta['uploaded_by'], PDO::PARAM_INT);
    } else {
        $st->bindValue(':uploaded_by', null, PDO::PARAM_NULL);
    }

    $st->execute();
    return (int)$pdo->lastInsertId();
}

/** Proste strażniki uprawnień — możesz rozszerzyć warunkami domenowymi encji */
function files_require_view(): void   { requirePermission(['cmms.files.view','cmms.*','admin.*']); }
function files_require_edit(): void   { requirePermission(['cmms.files.edit','cmms.*','admin.*']); }
function files_require_upload(): void { requirePermission(['cmms.files.upload','cmms.*','admin.*']); }
function files_require_delete(): void { requirePermission(['cmms.files.delete','cmms.*','admin.*']); }
