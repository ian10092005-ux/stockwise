<?php

define('DB_HOST', getenv('MYSQLHOST')     ?: 'localhost');
define('DB_USER', getenv('MYSQLUSER')     ?: 'root');
define('DB_PASS', getenv('MYSQLPASSWORD') ?: '');
define('DB_NAME', getenv('MYSQLDATABASE') ?: 'StockWise');
define('DB_PORT', (int)(getenv('MYSQLPORT') ?: 3306));

$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database connection failed: ' . $conn->connect_error
    ]);
    exit;
}

$conn->set_charset('utf8mb4');

function respond($data, $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

function clean($conn, $value) {
    return $conn->real_escape_string(trim($value));
}
