<?php

define('DB_HOST', 'localhost');   // XAMPP MySQL host — always localhost
define('DB_USER', 'root');        // Default XAMPP username
define('DB_PASS', '');            // Default XAMPP password (empty string)
define('DB_NAME', 'StockWise');   // Must match the database name in your SQL script

$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database connection failed: ' . $conn->connect_error
    ]);
    exit;
}

$conn->set_charset('utf8mb4');

// Helper: send JSON response and exit
function respond($data, $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

// Helper: sanitize input
function clean($conn, $value) {
    return $conn->real_escape_string(trim($value));
}