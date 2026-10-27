<?php

declare(strict_types=1);

const DB_HOST = "127.0.0.1";
const DB_NAME = "devtok";
const DB_USER = "root";
const DB_PASS = "";

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $pdo = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
        DB_USER,
        DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );

    return $pdo;
}

function send_cors(): void
{
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type");

    if (($_SERVER["REQUEST_METHOD"] ?? "") === "OPTIONS") {
        http_response_code(204);
        exit;
    }
}

function json_response(mixed $data, int $code = 200): void
{
    http_response_code($code);
    header("Content-Type: application/json; charset=utf-8");
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function read_json(): array
{
    $raw = file_get_contents("php://input");
    $data = json_decode($raw ?: "", true);
    return is_array($data) ? $data : [];
}

function format_user(array $row): array
{
    return [
        "id" => (int) $row["id"],
        "name" => $row["name"],
        "username" => $row["username"],
        "email" => $row["email"],
        "phone" => $row["phone"],
        "website" => $row["website"],
        "address" => [
            "street" => $row["street"],
            "suite" => $row["suite"],
            "city" => $row["city"],
            "zipcode" => $row["zipcode"],
        ],
        "company" => [
            "name" => $row["company"],
        ],
    ];
}

function format_post(array $row): array
{
    $post = [
        "id" => (int) $row["id"],
        "userId" => (int) $row["user_id"],
        "title" => $row["title"],
        "body" => $row["body"],
        "category" => $row["category"],
    ];

    if (array_key_exists("commentCount", $row)) {
        $post["commentCount"] = (int) $row["commentCount"];
    }

    return $post;
}

function format_comment(array $row): array
{
    return [
        "id" => (int) $row["id"],
        "postId" => (int) $row["post_id"],
        "name" => $row["name"],
        "email" => $row["email"],
        "body" => $row["body"],
    ];
}
