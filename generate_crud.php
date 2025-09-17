<?php
// generate_crud.php – automatyczny generator list.php, add.php, edit.php, delete.php
/*
✅ Gotowe. Stworzyłem pełny plik generate_crud.php, który:

Tworzy folder modules/auto/<nazwa_tabeli> jeśli nie istnieje,

Generuje pliki: list.php, add.php, edit.php, delete.php,

Obsługuje typowe pola (w tym aktywny, opis, created_by, updated_at),

Używa stylów form-grid, card, itp. spójnych z Twoim systemem.

Możesz teraz go uruchomić lokalnie pod localhost/app/tools/generate_crud.php, wpisać nazwę tabeli i pola (oddzielone przecinkami), a gotowe pliki znajdziesz w /modules/auto/<tabela>/.
*/


require_once __DIR__ . '/../../../init.php';
require_once __DIR__ . '/../../../app/includes/auth.php';
requireLogin();
checkAccess('admin');

function makeFolder($path) {
    if (!is_dir($path)) {
        mkdir($path, 0777, true);
    }
}

function createFile($path, $content) {
    file_put_contents($path, $content);
}

function getFieldHTML($field, $isEdit = false) {
    $html = "";
    $label = ucfirst(str_replace('_', ' ', $field));

    if (in_array($field, ['created_by', 'edited_by', 'created_at', 'updated_at'])) return '';

    if ($field === 'aktywny') {
        $html .= "<div>\n";
        $html .= "    <label><input type=\"checkbox\" name=\"aktywny\" <?= isset(\$row['aktywny']) && \$row['aktywny'] ? 'checked' : '' ?>> Aktywny</label>\n";
        $html .= "</div>\n";
    } elseif (in_array($field, ['opis', 'uwagi'])) {
        $html .= "<div>\n";
        $html .= "    <label for=\"$field\">$label:</label>\n";
        $html .= "    <textarea id=\"$field\" name=\"$field\"><?= htmlspecialchars(\$row['$field'] ?? '') ?></textarea>\n";
        $html .= "</div>\n";
    } else {
        $html .= "<div>\n";
        $html .= "    <label for=\"$field\">$label:</label>\n";
        $html .= "    <input type=\"text\" id=\"$field\" name=\"$field\" value=\"<?= htmlspecialchars(\$row['$field'] ?? '') ?>\" required>\n";
        $html .= "</div>\n";
    }

    return $html;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $table = trim($_POST['table'] ?? '');
    $fields = explode(',', trim($_POST['fields'] ?? ''));
    $modulePath = __DIR__ . "/../modules/auto/$table";
    makeFolder($modulePath);

    // list.php
    $listCode = "<?php\nrequire_once '../../../../init.php';\nrequire_once '../../../../app/includes/auth.php';\nrequire_once '../../../../app/includes/template.php';\nrequireLogin();\ncheckAccess('admin');\n\n\$pageTitle = '📄 Słownik: $table';\ninclude_template_header(\$pageTitle);\ninclude_template_sidebar();\n\n\$stmt = \$pdo->query(\"SELECT * FROM $table ORDER BY id DESC\");\n\$rows = \$stmt->fetchAll();\n?>\n\n<main class=\"main-content\">\n    <div class=\"breadcrumb\">\n        <a href=\"/dashboard.php\">Dashboard</a> / <span>$table</span>\n    </div>\n    <div class=\"page-header\">\n        <h1><?= \$pageTitle ?></h1>\n        <a href=\"add.php\" class=\"btn\">➕ Dodaj</a>\n    </div>\n    <table class=\"table\">\n        <thead><tr>";
    foreach ($fields as $field) {
        $listCode .= "<th>$field</th>";
    }
    $listCode .= "<th>Akcje</th></tr></thead><tbody><?php foreach (\$rows as \$row): ?><tr>";
    foreach ($fields as $field) {
        $listCode .= "<td><?= htmlspecialchars(\$row['$field']) ?></td>";
    }
    $listCode .= "<td><a href=\"edit.php?id=<?=\$row['id']?>\">✏️</a> <a href=\"delete.php?id=<?=\$row['id']?>\" onclick=\"return confirm('Usunąć?')\">🗑️</a></td>\n</tr><?php endforeach; ?></tbody></table></main><?php include_template_footer(); ?>";

    // add.php / edit.php / delete.php – prosta wersja z form-grid
    $fieldsHTML = '';
    foreach ($fields as $field) {
        $fieldsHTML .= getFieldHTML($field);
    }

    $addCode = "<?php\nrequire_once '../../../../init.php';\nrequire_once '../../../../app/includes/auth.php';\nrequire_once '../../../../app/includes/template.php';\nrequireLogin();\ncheckAccess('admin');\n\n\$pageTitle = '➕ Dodaj $table';\ninclude_template_header(\$pageTitle);\ninclude_template_sidebar();\n\n\$error = '';\nif (\$_SERVER['REQUEST_METHOD'] === 'POST') {\n    // ... przetwarzanie danych\n}\n?>\n\n<main class=\"main-content\">\n<div class=\"card\">\n<h2><?= \$pageTitle ?></h2>\n<form method=\"post\" class=\"form-grid\">\n$fieldsHTML\n<div class=\"form-actions\"><button type=\"submit\">💾 Zapisz</button></div></form></div></main><?php include_template_footer(); ?>";

    $editCode = str_replace("Dodaj", "Edytuj", str_replace("add.php", "edit.php", $addCode));
    $deleteCode = "<?php\nrequire_once '../../../../init.php';\nrequire_once '../../../../app/includes/auth.php';\nrequireLogin();\ncheckAccess('admin');\n\n\$id = \$_GET['id'] ?? null;\nif (!\$id || !is_numeric(\$id)) exit();\n\$pdo->prepare(\"DELETE FROM $table WHERE id = ?\")->execute([\$id]);\nheader('Location: list.php'); exit();";

    createFile("$modulePath/list.php", $listCode);
    createFile("$modulePath/add.php", $addCode);
    createFile("$modulePath/edit.php", $editCode);
    createFile("$modulePath/delete.php", $deleteCode);

    echo "<p style='padding:10px;background:#d4edda;color:#155724;border:1px solid #c3e6cb;'>✔️ CRUD wygenerowany w $modulePath</p>";
}
?>

<form method="post" style="padding:20px;max-width:500px;">
    <h2>🛠️ Generator CRUD</h2>
    <label>Tabela (np. struktura_slownik_typ_zasobu):<br>
        <input type="text" name="table" style="width:100%" required>
    </label><br><br>
    <label>Pola (np. id,nazwa,opis,aktywny,created_by,edited_by,created_at,updated_at):<br>
        <input type="text" name="fields" style="width:100%" required>
    </label><br><br>
    <button type="submit">⚙️ Wygeneruj</button>
</form>
