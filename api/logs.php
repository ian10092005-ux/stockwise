<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole(['admin']);

$limit  = isset($_GET['limit'])  ? (int)$_GET['limit']  : 50;
$offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
$type   = isset($_GET['type'])   ? clean($conn, $_GET['type']) : '';

$where = $type ? "WHERE sm.type = '$type'" : '';

$sql = "SELECT sm.movement_id, sm.type, sm.quantity_change, sm.remarks, sm.moved_at,
               p.name AS product_name, p.sku_code,
               pv.variant_name,
               u.username,
               CONCAT(e.first_name, ' ', e.last_name) AS full_name
        FROM stock_movements sm
        JOIN products p         ON sm.product_id = p.product_id
        JOIN user_account u     ON sm.user_id    = u.user_id
        JOIN employees e        ON u.employee_id = e.employee_id
        LEFT JOIN product_variants pv ON sm.variant_id = pv.variant_id
        $where
        ORDER BY sm.moved_at DESC
        LIMIT $limit OFFSET $offset";

$result = $conn->query($sql);
$rows   = [];
while ($row = $result->fetch_assoc()) $rows[] = $row;

// Total count for pagination
$countSql = "SELECT COUNT(*) AS total FROM stock_movements sm $where";
$total    = (int)$conn->query($countSql)->fetch_assoc()['total'];

respond(['success' => true, 'data' => $rows, 'total' => $total]);