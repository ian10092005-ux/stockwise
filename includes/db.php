<?php

define('DB_HOST', 'roundhouse.proxy.rlwy.net');  // public host
define('DB_USER', 'root');                          // MYSQLUSER
define('DB_PASS', 'SIsOubEKbWthTLkvGbqJBLQwiDdpSKks');                  // MYSQLPASSWORD
define('DB_NAME', 'railway');                       // MYSQLDATABASE
define('DB_PORT', '12345');                         // MYSQLPORT

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
