<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole(); // all logged-in users can access (PUT is self-service; others are admin-only)

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    requireRole(['admin']);
    $result = $conn->query(
        "SELECT u.user_id, u.username, u.role,
                CONCAT(e.first_name, ' ', e.last_name) AS full_name
         FROM user_account u
         JOIN employees e ON u.employee_id = e.employee_id
         ORDER BY u.role, u.username"
    );
    $rows = [];
    while ($row = $result->fetch_assoc()) $rows[] = $row;
    respond(['success' => true, 'data' => $rows]);
}

if ($method === 'POST') {
    requireRole(['admin']);
    $input     = json_decode(file_get_contents('php://input'), true);
    $username  = clean($conn, $input['username']   ?? '');
    $role      = clean($conn, $input['role']       ?? '');
    $password  = $input['password'] ?? '';
    $firstName = clean($conn, $input['first_name'] ?? '');
    $lastName  = clean($conn, $input['last_name']  ?? '');

    if (!$username || !$role || !$password)
        respond(['success' => false, 'message' => 'Username, role, and password are required.'], 400);
    if (!in_array($role, ['admin', 'stock_manager', 'cashier']))
        respond(['success' => false, 'message' => 'Invalid role.'], 400);
    if (strlen($password) < 8)
        respond(['success' => false, 'message' => 'Password must be at least 8 characters.'], 400);

    // Use username as fallback name if first/last not provided
    if (!$firstName) $firstName = $username;
    if (!$lastName)  $lastName  = '';

    // Check duplicate username
    $check = $conn->query("SELECT user_id FROM user_account WHERE username='$username'")->num_rows;
    if ($check > 0) respond(['success' => false, 'message' => 'Username already exists.'], 409);

    $hash = password_hash($password, PASSWORD_BCRYPT);
    $hash = clean($conn, $hash);

    // Create employee record with split name columns
    $conn->query("INSERT INTO employees (first_name, last_name) VALUES ('$firstName', '$lastName')");
    $emp_id = $conn->insert_id;

    $sql = "INSERT INTO user_account (employee_id, username, password_hash, role)
            VALUES ($emp_id, '$username', '$hash', '$role')";
    if ($conn->query($sql))
        respond(['success' => true, 'message' => 'User created.', 'id' => $conn->insert_id], 201);
    respond(['success' => false, 'message' => $conn->error], 500);
}

if ($method === 'PUT') {
    // Self-service password change — any logged-in user
    $input    = json_decode(file_get_contents('php://input'), true);
    $uid      = currentUserId();
    $current  = $input['current_password'] ?? '';
    $newpass  = $input['new_password']     ?? '';

    if (!$current || !$newpass)
        respond(['success' => false, 'message' => 'Current and new password are required.'], 400);
    if (strlen($newpass) < 8)
        respond(['success' => false, 'message' => 'New password must be at least 8 characters.'], 400);

    $row = $conn->query("SELECT password_hash FROM user_account WHERE user_id=$uid")->fetch_assoc();
    if (!$row) respond(['success' => false, 'message' => 'User not found.'], 404);

    if (!password_verify($current, $row['password_hash']))
        respond(['success' => false, 'message' => 'Current password is incorrect.'], 401);

    $hash = clean($conn, password_hash($newpass, PASSWORD_BCRYPT));
    $conn->query("UPDATE user_account SET password_hash='$hash' WHERE user_id=$uid");
    respond(['success' => true, 'message' => 'Password updated successfully.']);
}

if ($method === 'DELETE') {
    if (!$id) respond(['success' => false, 'message' => 'User ID required.'], 400);

    if ($id === currentUserId())
        respond(['success' => false, 'message' => 'You cannot delete your own account.'], 403);

    $row = $conn->query("SELECT employee_id FROM user_account WHERE user_id=$id")->fetch_assoc();
    if (!$row) respond(['success' => false, 'message' => 'User not found.'], 404);

    $conn->query("DELETE FROM user_account WHERE user_id=$id");
    respond(['success' => true, 'message' => 'User deleted.']);
}