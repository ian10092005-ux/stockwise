<?php

require_once '../includes/headers.php';
require_once '../includes/db.php';

session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(['success' => false, 'message' => 'Method not allowed.'], 405);
}

$input    = json_decode(file_get_contents('php://input'), true);
$username = clean($conn, $input['username'] ?? '');
$password = $input['password'] ?? '';

if (!$username || !$password) {
    respond(['success' => false, 'message' => 'Username and password are required.'], 400);
}

$sql    = "SELECT user_id, username, password_hash, role FROM user_account WHERE username = '$username' LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows === 0) {
    respond(['success' => false, 'message' => 'Invalid username or password.'], 401);
}

$user = $result->fetch_assoc();

// CORRECT: uses PHP's password_verify() with bcrypt hashes stored in DB
if (!password_verify($password, $user['password_hash'])) {
    respond(['success' => false, 'message' => 'Invalid username or password.'], 401);
}

$_SESSION['user_id']  = $user['user_id'];
$_SESSION['username'] = $user['username'];
$_SESSION['role']     = $user['role'];

respond([
    'success'  => true,
    'user_id'  => $user['user_id'],
    'username' => $user['username'],
    'role'     => $user['role']
]);
