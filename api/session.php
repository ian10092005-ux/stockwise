<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

if (empty($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Not logged in.']);
    exit;
}

$uid = (int)$_SESSION['user_id'];
$row = $conn->query(
    "SELECT u.user_id, u.username, u.role,
            CONCAT(e.first_name, ' ', e.last_name) AS full_name,
            e.email
     FROM user_account u
     JOIN employees e ON u.employee_id = e.employee_id
     WHERE u.user_id = $uid"
)->fetch_assoc();

echo json_encode([
    'success'   => true,
    'user_id'   => $row['user_id'],
    'username'  => $row['username'],
    'role'      => $row['role'],
    'full_name' => $row['full_name'],
    'email'     => $row['email'],
]);