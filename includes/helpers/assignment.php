<?php
// --- AUTO-PICK GRUPY wg: (type+subtype+structure chain) -> (type+subtype) -> (type) ---

if (!function_exists('cmms_structure_chain')) {
    /** Zwraca [self, parent, parent2, ...] dla węzła struktury (self-first). */
    function cmms_structure_chain(PDO $pdo, ?int $structureId): array {
        if (!$structureId || $structureId <= 0) return [];
        $out = [];
        $cur = (int)$structureId; $guard = 0;
        while ($cur && $guard++ < 1000) {
            $out[] = $cur;
            $st = $pdo->prepare("SELECT parent_id FROM cmms_struktura WHERE id = :id");
            $st->execute([':id'=>$cur]);
            $cur = (int)($st->fetchColumn() ?: 0);
        }
        return $out;
    }
}

if (!function_exists('cmms_auto_pick_group')) {
    /**
     * Zwraca najlepsze dopasowanie grupy (ID) dla danego zestawu:
     * 1) (type + subtype + structure: self, potem przodkowie) w oparciu o reguły z structure_id=@level i scope IN ('node','subtree')
     * 2) fallback: (type + subtype) bez struktury
     * 3) fallback: (type) bez podtypu/struktury
     * 4) ostatecznie: stała CMMS_DEFAULT_GROUP_ID (jeśli zdefiniowana) lub null
     */
    function cmms_auto_pick_group(PDO $pdo, int $typeId, ?int $subtypeId, ?int $structureId): ?int {
        // 1) struktura: self -> rodzice
        $levels = cmms_structure_chain($pdo, $structureId);
        if ($levels) {
            foreach ($levels as $L) {
                if ($subtypeId !== null) {
                    $sql = "
                        SELECT r.target_group_id
                          FROM cmms_assignment_rule r
                         WHERE r.active=1
                           AND r.type_id = :t
                           AND r.subtype_id = :s
                           AND r.structure_id = :L
                           AND r.structure_scope IN ('node','subtree')
                           AND (r.valid_from IS NULL OR NOW() >= r.valid_from)
                           AND (r.valid_to   IS NULL OR NOW() <= r.valid_to)
                         ORDER BY r.priority ASC, r.id ASC
                         LIMIT 1
                    ";
                    $st = $pdo->prepare($sql);
                    $st->execute([':t'=>$typeId, ':s'=>$subtypeId, ':L'=>$L]);
                } else {
                    $sql = "
                        SELECT r.target_group_id
                          FROM cmms_assignment_rule r
                         WHERE r.active=1
                           AND r.type_id = :t
                           AND r.subtype_id IS NULL
                           AND r.structure_id = :L
                           AND r.structure_scope IN ('node','subtree')
                           AND (r.valid_from IS NULL OR NOW() >= r.valid_from)
                           AND (r.valid_to   IS NULL OR NOW() <= r.valid_to)
                         ORDER BY r.priority ASC, r.id ASC
                         LIMIT 1
                    ";
                    $st = $pdo->prepare($sql);
                    $st->execute([':t'=>$typeId, ':L'=>$L]);
                }
                $gid = (int)($st->fetchColumn() ?: 0);
                if ($gid > 0) return $gid;
            }
        }

        // 2) tylko type + subtype (bez struktury)
        if ($subtypeId !== null) {
            $st = $pdo->prepare("
                SELECT r.target_group_id
                  FROM cmms_assignment_rule r
                 WHERE r.active=1
                   AND r.type_id = :t
                   AND r.subtype_id = :s
                   AND (r.valid_from IS NULL OR NOW() >= r.valid_from)
                   AND (r.valid_to   IS NULL OR NOW() <= r.valid_to)
                 ORDER BY r.priority ASC, r.id ASC
                 LIMIT 1
            ");
            $st->execute([':t'=>$typeId, ':s'=>$subtypeId]);
            $gid = (int)($st->fetchColumn() ?: 0);
            if ($gid > 0) return $gid;
        }

        // 3) tylko type (bez podtypu/struktury)
        $st = $pdo->prepare("
            SELECT r.target_group_id
              FROM cmms_assignment_rule r
             WHERE r.active=1
               AND r.type_id = :t
               AND (r.valid_from IS NULL OR NOW() >= r.valid_from)
               AND (r.valid_to   IS NULL OR NOW() <= r.valid_to)
             ORDER BY r.priority ASC, r.id ASC
             LIMIT 1
        ");
        $st->execute([':t'=>$typeId]);
        $gid = (int)($st->fetchColumn() ?: 0);
        if ($gid > 0) return $gid;

        // 4) default lub null
        if (defined('CMMS_DEFAULT_GROUP_ID') && (int)CMMS_DEFAULT_GROUP_ID > 0) {
            return (int)CMMS_DEFAULT_GROUP_ID;
        }
        return null;
    }
}
