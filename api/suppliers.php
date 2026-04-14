<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole();

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    $where  = $id ? "WHERE s.supplier_id = $id" : '';
    $sql    = "SELECT s.supplier_id, s.name, s.contact_person, s.phone, s.address, s.email,
                      COUNT(DISTINCT p.product_id) AS product_count
               FROM suppliers s LEFT JOIN products p ON s.supplier_id = p.supplier_id $where
               GROUP BY s.supplier_id ORDER BY s.name";
    $result = $conn->query($sql);
    $rows   = [];
    while ($row = $result->fetch_assoc()) $rows[] = $row;
    respond(['success' => true, 'data' => $id ? ($rows[0] ?? null) : $rows]);
}

if ($method === 'POST') {
    requireRole(['admin', 'stock_manager']);
    $input         = json_decode(file_get_contents('php://input'), true);
    $name          = clean($conn, $input['name']           ?? '');
    $contactPerson = clean($conn, $input['contact_person'] ?? '');
    $phone         = clean($conn, $input['phone']          ?? '');
    $address       = clean($conn, $input['address']        ?? '');
    $email         = clean($conn, $input['email']          ?? '');
    if (!$name) respond(['success' => false, 'message' => 'Supplier name is required.'], 400);
    $sql = "INSERT INTO suppliers (name, contact_person, phone, address, email)
            VALUES ('$name', '$contactPerson', '$phone', '$address', '$email')";
    if ($conn->query($sql)) respond(['success' => true, 'message' => 'Supplier added.', 'id' => $conn->insert_id], 201);
    respond(['success' => false, 'message' => $conn->error], 500);
}

if ($method === 'PUT') {
    requireRole(['admin', 'stock_manager']);
    if (!$id) respond(['success' => false, 'message' => 'Supplier ID required.'], 400);
    $input         = json_decode(file_get_contents('php://input'), true);
    $name          = clean($conn, $input['name']           ?? '');
    $contactPerson = clean($conn, $input['contact_person'] ?? '');
    $phone         = clean($conn, $input['phone']          ?? '');
    $address       = clean($conn, $input['address']        ?? '');
    $email         = clean($conn, $input['email']          ?? '');
    $sql = "UPDATE suppliers
            SET name='$name', contact_person='$contactPerson', phone='$phone',
                address='$address', email='$email'
            WHERE supplier_id=$id";
    if ($conn->query($sql)) respond(['success' => true, 'message' => 'Supplier updated.']);
    respond(['success' => false, 'message' => $conn->error], 500);
}

if ($method === 'DELETE') {
    requireRole(['admin']);
    if (!$id) respond(['success' => false, 'message' => 'Supplier ID required.'], 400);
    $check = $conn->query("SELECT COUNT(*) AS cnt FROM products WHERE supplier_id=$id")->fetch_assoc();
    if ($check['cnt'] > 0) respond(['success' => false, 'message' => 'Cannot delete: supplier has linked products.'], 409);
    if ($conn->query("DELETE FROM suppliers WHERE supplier_id=$id"))
        respond(['success' => true, 'message' => 'Supplier deleted.']);
    respond(['success' => false, 'message' => $conn->error], 500);
}