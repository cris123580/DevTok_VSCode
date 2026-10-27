<?php

declare(strict_types=1);

require __DIR__ . "/config.php";

send_cors();

$method = $_SERVER["REQUEST_METHOD"] ?? "GET";

try {
    $pdo = db();

    if ($method === "GET") {
        $postId = isset($_GET["postId"]) ? (int) $_GET["postId"] : 0;

        if ($postId <= 0) {
            json_response(["error" => "Geef postId mee."], 400);
        }

        $statement = $pdo->prepare(
            "SELECT id, post_id, name, email, body
             FROM comments
             WHERE post_id = :postId
             ORDER BY id DESC"
        );
        $statement->execute([":postId" => $postId]);
        json_response(array_map("format_comment", $statement->fetchAll()));
    }

    if ($method === "POST") {
        $data = read_json();
        $postId = (int) ($data["postId"] ?? 0);
        $name = trim((string) ($data["name"] ?? ""));
        $body = trim((string) ($data["body"] ?? ""));
        $email = trim((string) ($data["email"] ?? ""));

        if ($postId <= 0 || $name === "" || $body === "") {
            json_response(["error" => "Naam, tekst en postId zijn verplicht."], 400);
        }

        if ($email === "") {
            $slug = strtolower(preg_replace("/\s+/", ".", $name) ?? "user");
            $email = $slug . "@devtok.demo";
        }

        $exists = $pdo->prepare("SELECT id FROM posts WHERE id = :id");
        $exists->execute([":id" => $postId]);

        if (!$exists->fetch()) {
            json_response(["error" => "Bericht niet gevonden."], 404);
        }

        $insert = $pdo->prepare(
            "INSERT INTO comments (post_id, name, email, body)
             VALUES (:postId, :name, :email, :body)"
        );
        $insert->execute([
            ":postId" => $postId,
            ":name" => mb_substr($name, 0, 100),
            ":email" => mb_substr($email, 0, 120),
            ":body" => mb_substr($body, 0, 1000),
        ]);

        json_response([
            "id" => (int) $pdo->lastInsertId(),
            "postId" => $postId,
            "name" => $name,
            "email" => $email,
            "body" => $body,
        ], 201);
    }

    json_response(["error" => "Methode niet toegestaan."], 405);
} catch (PDOException $error) {
    json_response(["error" => "Databasefout. Controleer of database devtok bestaat."], 500);
}
