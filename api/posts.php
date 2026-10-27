<?php

declare(strict_types=1);

require __DIR__ . "/config.php";

send_cors();

try {
    $pdo = db();
    $id = isset($_GET["id"]) ? (int) $_GET["id"] : 0;

    if ($id > 0) {
        $statement = $pdo->prepare(
            "SELECT id, user_id, title, body, category,
                    (SELECT COUNT(*) FROM comments WHERE post_id = posts.id) AS commentCount
             FROM posts
             WHERE id = :id"
        );
        $statement->execute([":id" => $id]);
        $row = $statement->fetch();

        if (!$row) {
            json_response(["error" => "Bericht niet gevonden."], 404);
        }

        json_response(format_post($row));
    }

    $statement = $pdo->query(
        "SELECT id, user_id, title, body, category,
                (SELECT COUNT(*) FROM comments WHERE post_id = posts.id) AS commentCount
         FROM posts
         ORDER BY id ASC"
    );

    json_response(array_map("format_post", $statement->fetchAll()));
} catch (PDOException $error) {
    json_response(["error" => "Databasefout. Controleer of database devtok bestaat."], 500);
}
