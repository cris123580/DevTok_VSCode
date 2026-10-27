<?php

declare(strict_types=1);

require __DIR__ . "/config.php";

send_cors();

try {
    $pdo = db();
    $id = isset($_GET["id"]) ? (int) $_GET["id"] : 0;

    if ($id > 0) {
        $statement = $pdo->prepare(
            "SELECT id, name, username, email, phone, website, street, suite, city, zipcode, company
             FROM users
             WHERE id = :id"
        );
        $statement->execute([":id" => $id]);
        $row = $statement->fetch();

        if (!$row) {
            json_response(["error" => "Gebruiker niet gevonden."], 404);
        }

        json_response(format_user($row));
    }

    $statement = $pdo->query(
        "SELECT id, name, username, email, phone, website, street, suite, city, zipcode, company
         FROM users
         ORDER BY id ASC"
    );

    json_response(array_map("format_user", $statement->fetchAll()));
} catch (PDOException $error) {
    json_response(["error" => "Databasefout. Controleer of database devtok bestaat."], 500);
}
