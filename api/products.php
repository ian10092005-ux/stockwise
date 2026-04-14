<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole(); // must be logged in

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    if ($id) {
        $sql    = "SELECT p.*, c.name AS category_name, b.name AS brand_name, s.name AS supplier_name
                   FROM products p
                   JOIN categories c ON p.category_id = c.category_id
                   JOIN brands     b ON p.brand_id    = b.brand_id
                   JOIN suppliers  s ON p.supplier_id = s.supplier_id
                   WHERE p.product_id = $id";
        $result = $conn->query($sql);
        if ($result->num_rows === 0) respond(['success' => false, 'message' => 'Product not found.'], 404);
        respond(['success' => true, 'data' => $result->fetch_assoc()]);
    }
    $sql = "SELECT p.product_id, p.sku_code, p.name,
                   c.name AS category, b.name AS brand, s.name AS supplier,
                   p.price, p.unit, p.reorder_level,
                   IFNULL(SUM(i.current_stock), 0) AS total_stock,
                   CASE
                     WHEN IFNULL(SUM(i.current_stock),0) = 0                              THEN 'Out of Stock'
                     WHEN IFNULL(SUM(i.current_stock),0) <= p.reorder_level               THEN 'Reorder Now'
                     WHEN IFNULL(SUM(i.current_stock),0) <= p.reorder_level * 1.5         THEN 'Low Stock'
                     ELSE 'Sufficient'
                   END AS stock_status
            FROM products p
            JOIN categories c  ON p.category_id  = c.category_id
            JOIN brands     b  ON p.brand_id      = b.brand_id
            JOIN suppliers  s  ON p.supplier_id   = s.supplier_id
            LEFT JOIN inventory i ON p.product_id = i.product_id
            GROUP BY p.product_id ORDER BY c.name, p.name";
    $result   = $conn->query($sql);
    $products = [];
    while ($row = $result->fetch_assoc()) $products[] = $row;
    respond(['success' => true, 'data' => $products, 'count' => count($products)]);
}

if ($method === 'POST') {
    requireRole(['admin', 'stock_manager']); // cashiers cannot add products
    $input       = json_decode(file_get_contents('php://input'), true);
    $sku         = clean($conn, $input['sku_code']     ?? '');
    $name        = clean($conn, $input['name']         ?? '');
    $category_id = (int)($input['category_id']         ?? 0);
    $brand_id    = (int)($input['brand_id']            ?? 0);
    $supplier_id = (int)($input['supplier_id']         ?? 0);
    $price       = (float)($input['price']             ?? 0);
    $unit        = clean($conn, $input['unit']         ?? '');
    $reorder     = (int)($input['reorder_level']       ?? 10);
    if (!$sku || !$name || !$category_id || !$brand_id || !$supplier_id || !$price || !$unit)
        respond(['success' => false, 'message' => 'All fields are required.'], 400);
    $sql = "INSERT INTO products (sku_code,name,category_id,brand_id,supplier_id,price,unit,reorder_level)
            VALUES ('$sku','$name',$category_id,$brand_id,$supplier_id,$price,'$unit',$reorder)";
    if ($conn->query($sql)) respond(['success' => true, 'message' => 'Product added.', 'id' => $conn->insert_id], 201);
    respond(['success' => false, 'message' => $conn->error], 500);
}

if ($method === 'PUT') {
    requireRole(['admin', 'stock_manager']);
    if (!$id) respond(['success' => false, 'message' => 'Product ID required.'], 400);
    $input       = json_decode(file_get_contents('php://input'), true);
    $name        = clean($conn, $input['name']         ?? '');
    $category_id = (int)($input['category_id']         ?? 0);
    $brand_id    = (int)($input['brand_id']            ?? 0);
    $supplier_id = (int)($input['supplier_id']         ?? 1);
    $price       = (float)($input['price']             ?? 0);
    $unit        = clean($conn, $input['unit']         ?? '');
    $reorder     = (int)($input['reorder_level']       ?? 10);
    $sql = "UPDATE products SET name='$name',category_id=$category_id,brand_id=$brand_id,
            supplier_id=$supplier_id,price=$price,unit='$unit',reorder_level=$reorder
            WHERE product_id=$id";
    if ($conn->query($sql)) respond(['success' => true, 'message' => 'Product updated.']);
    respond(['success' => false, 'message' => $conn->error], 500);
}

if ($method === 'DELETE') {
    requireRole(['admin']); // only admin can delete products
    if (!$id) respond(['success' => false, 'message' => 'Product ID required.'], 400);
    $check = $conn->query("SELECT COUNT(*) AS cnt FROM inventory WHERE product_id = $id")->fetch_assoc();
    if ($check['cnt'] > 0)
        respond(['success' => false, 'message' => 'Cannot delete: product has inventory records.'], 409);
    if ($conn->query("DELETE FROM products WHERE product_id = $id"))
        respond(['success' => true, 'message' => 'Product deleted.']);
    respond(['success' => false, 'message' => $conn->error], 500);
}
