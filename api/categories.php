<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';
requireRole();
$result = $conn->query("SELECT category_id, name FROM categories ORDER BY name");
$rows = [];
while ($row = $result->fetch_assoc()) $rows[] = $row;
respond(['success' => true, 'data' => $rows]);