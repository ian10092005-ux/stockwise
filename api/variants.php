<?php
// api/variants.php — returns variants for a given product_id
require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';
requireRole();
$product_id = isset($_GET['product_id']) ? (int)$_GET['product_id'] : 0;
if (!$product_id) respond(['success' => false, 'message' => 'product_id required'], 400);
$result = $conn->query("SELECT variant_id, variant_name, size_grams, additional_price FROM product_variants WHERE product_id = $product_id ORDER BY variant_name");
$rows = [];
while ($row = $result->fetch_assoc()) $rows[] = $row;
respond(['success' => true, 'data' => $rows]);