<?php

session_start();

function requireRole(array $allowedRoles = []) {
    // Check if user is logged in
    if (empty($_SESSION['user_id'])) {
        http_response_code(401);
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Not logged in. Please log in first.', 'redirect' => '../login.html']);
        exit;
    }

    // If specific roles required, check them
    if (!empty($allowedRoles) && !in_array($_SESSION['role'], $allowedRoles)) {
        http_response_code(403);
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Access denied. Your role (' . $_SESSION['role'] . ') does not have permission for this action.']);
        exit;
    }
}

// Helper to get current session role
function currentRole() {
    return $_SESSION['role'] ?? null;
}

function currentUserId() {
    return $_SESSION['user_id'] ?? null;
}
