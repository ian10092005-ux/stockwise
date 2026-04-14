<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole();

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    $where = $id ? "WHERE i.inventory_id = $id" : '';
    $sql = "SELECT i.inventory_id, i.batch_number,
                   p.product_id, p.name AS product_name, p.sku_code,
                   c.name AS category, pv.variant_name,
                   i.current_stock, p.reorder_level, p.price,
                   i.delivery_date, i.expiration_date,
                   DATEDIFF(i.expiration_date, CURDATE()) AS days_until_expiry,
                   CASE
                     WHEN i.expiration_date < CURDATE()                              THEN 'Expired'
                     WHEN i.expiration_date < DATE_ADD(CURDATE(), INTERVAL 30 DAY)  THEN 'Expiring Soon'
                     WHEN i.expiration_date < DATE_ADD(CURDATE(), INTERVAL 90 DAY)  THEN 'Near Expiry'
                     ELSE 'Good'
                   END AS expiry_status,
                   CASE
                     WHEN i.current_stock = 0                          THEN 'Out of Stock'
                     WHEN i.current_stock <= p.reorder_level           THEN 'Reorder Now'
                     WHEN i.current_stock <= p.reorder_level * 1.5     THEN 'Low Stock'
                     ELSE 'Sufficient'
                   END AS stock_status,
                   CASE
                     WHEN i.delivery_date IS NOT NULL AND i.delivery_date > CURDATE() THEN 'Pending'
                     ELSE 'Delivered'
                   END AS delivery_status,
                   s.name AS supplier,
                   s.contact_person AS supplier_contact,
                   s.phone AS supplier_phone
            FROM inventory i
            JOIN products        p  ON i.product_id  = p.product_id
            JOIN categories      c  ON p.category_id = c.category_id
            JOIN suppliers       s  ON p.supplier_id = s.supplier_id
            LEFT JOIN product_variants pv ON i.variant_id = pv.variant_id
            $where
            ORDER BY i.expiration_date ASC";
    $result  = $conn->query($sql);
    $batches = [];
    while ($row = $result->fetch_assoc()) $batches[] = $row;
    if ($id) respond(['success' => true, 'data' => $batches[0] ?? null]);
    respond(['success' => true, 'data' => $batches, 'count' => count($batches)]);
}

if ($method === 'POST') {
    requireRole(['admin', 'stock_manager']);
    $input      = json_decode(file_get_contents('php://input'), true);
    $product_id = (int)($input['product_id']     ?? 0);
    $variant_id = !empty($input['variant_id']) ? (int)$input['variant_id'] : null;
    $batch      = clean($conn, $input['batch_number']    ?? '');
    $stock      = (int)($input['current_stock']  ?? 0);
    $delivery   = clean($conn, $input['delivery_date']   ?? date('Y-m-d'));
    $expiry     = clean($conn, $input['expiration_date'] ?? '');
    if (!$product_id || !$expiry) respond(['success' => false, 'message' => 'Product and expiration date required.'], 400);
    if (!$batch) $batch = 'BATCH-' . date('Y') . '-' . str_pad(rand(1,999), 3, '0', STR_PAD_LEFT);
    $vid_sql = ($variant_id !== null) ? $variant_id : 'NULL';
    $sql = "INSERT INTO inventory (product_id, variant_id, batch_number, current_stock, delivery_date, expiration_date)
            VALUES ($product_id, $vid_sql, '$batch', $stock, '$delivery', '$expiry')";
    if ($conn->query($sql)) {
        $inv_id = $conn->insert_id;
        $uid    = currentUserId();
        // Include inventory_id so the movement is traceable to this batch
        $conn->query("INSERT INTO stock_movements (inventory_id, product_id, variant_id, user_id, type, quantity_change, remarks)
                      VALUES ($inv_id, $product_id, $vid_sql, $uid, 'IN', $stock, 'New batch $batch received')");
        respond(['success' => true, 'message' => 'Batch added.', 'id' => $inv_id], 201);
    }
    respond(['success' => false, 'message' => $conn->error], 500);
}

if ($method === 'PUT') {
    requireRole(['admin', 'stock_manager']);
    if (!$id) respond(['success' => false, 'message' => 'Inventory ID required.'], 400);
    $input = json_decode(file_get_contents('php://input'), true);

    // ── Dispose action: log to stock_movements then delete batch ──
    if (!empty($input['dispose'])) {
        $remarks = clean($conn, $input['remarks'] ?? 'Disposed — expired stock');
        $uid     = currentUserId();

        $batch = $conn->query("SELECT i.inventory_id, i.product_id, i.variant_id, i.current_stock, i.batch_number
                                FROM inventory i WHERE i.inventory_id=$id")->fetch_assoc();
        if (!$batch) respond(['success' => false, 'message' => 'Batch not found.'], 404);
        // Allow disposing zero-stock expired batches for cleanup (skip the stock > 0 guard)

        $pid     = (int)$batch['product_id'];
        $vid     = $batch['variant_id'] ? (int)$batch['variant_id'] : 'NULL';
        $qty     = (int)$batch['current_stock'];
        $batchNo = clean($conn, $batch['batch_number']);

        $conn->begin_transaction();

        $insertSql = "INSERT INTO stock_movements (inventory_id, product_id, variant_id, user_id, type, quantity_change, remarks)
                      VALUES ($id, $pid, $vid, $uid, 'EXPIRED', $qty, '$batchNo — $remarks')";
        $insertOk = $conn->query($insertSql);

        if (!$insertOk) {
            $conn->rollback();
            respond(['success' => false, 'message' => 'Stock movement log failed: ' . $conn->error], 500);
        }

        // NULL out the inventory_id FK on the movement we just inserted before deleting
        // the batch — without this, the FK constraint (RESTRICT by default) blocks the DELETE
        $conn->query("UPDATE stock_movements SET inventory_id = NULL WHERE movement_id = " . $conn->insert_id);

        $deleteOk = $conn->query("DELETE FROM inventory WHERE inventory_id=$id");

        if (!$deleteOk) {
            $conn->rollback();
            respond(['success' => false, 'message' => 'Inventory delete failed: ' . $conn->error], 500);
        }

        $conn->commit();

        // Check total remaining stock vs reorder level for this product
        $stockCheck = $conn->query("SELECT p.name, p.reorder_level, p.price,
                                           IFNULL(SUM(i.current_stock),0) AS total_stock,
                                           s.name AS supplier, s.contact_person, s.phone
                                    FROM products p
                                    JOIN suppliers s ON p.supplier_id = s.supplier_id
                                    LEFT JOIN inventory i ON p.product_id = i.product_id
                                    WHERE p.product_id = $pid
                                    GROUP BY p.product_id")->fetch_assoc();

        $totalStock   = (int)$stockCheck['total_stock'];
        $reorderLevel = (int)$stockCheck['reorder_level'];
        $lowStock     = $totalStock <= $reorderLevel;

        respond([
            'success'       => true,
            'message'       => 'Batch disposed and removed.',
            'disposed_qty'  => $qty,
            'price'         => (float)$stockCheck['price'],
            'disposal_cost' => round($qty * (float)$stockCheck['price'], 2),
            'product_name'  => $stockCheck['name'],
            'low_stock'     => $lowStock,
            'total_stock'   => $totalStock,
            'reorder_level' => $reorderLevel,
            'supplier'      => $stockCheck['supplier'],
            'supplier_contact' => $stockCheck['contact_person'],
            'supplier_phone'   => $stockCheck['phone'],
        ]);
    }

    // ── Regular stock update ──────────────────────────────────────
    $stock    = (int)($input['current_stock']   ?? 0);
    $delivery = clean($conn, $input['delivery_date']   ?? '');
    $expiry   = clean($conn, $input['expiration_date'] ?? '');
    $sql = "UPDATE inventory SET current_stock=$stock, delivery_date='$delivery', expiration_date='$expiry' WHERE inventory_id=$id";
    if (!$conn->query($sql)) respond(['success' => false, 'message' => $conn->error], 500);

    // If stock just hit zero, log DEPLETED and hard-delete the batch
    if ($stock <= 0) {
        $uid     = currentUserId();
        $batchRow = $conn->query("SELECT product_id, variant_id, batch_number FROM inventory WHERE inventory_id=$id")->fetch_assoc();
        if ($batchRow) {
            $dpid    = (int)$batchRow['product_id'];
            $dvid    = $batchRow['variant_id'] ? (int)$batchRow['variant_id'] : 'NULL';
            $dbn     = $conn->real_escape_string($batchRow['batch_number']);
            $conn->query("INSERT INTO stock_movements (inventory_id, product_id, variant_id, user_id, type, quantity_change, remarks)
                          VALUES ($id, $dpid, $dvid, $uid, 'DEPLETED', 0, 'Batch $dbn set to zero via edit — auto-removed')");
            $conn->query("UPDATE stock_movements SET inventory_id = NULL WHERE inventory_id = $id");
            $conn->query("DELETE FROM inventory WHERE inventory_id=$id");
        }
        respond(['success' => true, 'message' => 'Batch set to zero and removed.']);
    }

    respond(['success' => true, 'message' => 'Batch updated.']);
}

if ($method === 'DELETE') {
    requireRole(['admin']);
    if (!$id) respond(['success' => false, 'message' => 'Inventory ID required.'], 400);
    if ($conn->query("DELETE FROM inventory WHERE inventory_id=$id"))
        respond(['success' => true, 'message' => 'Batch deleted.']);
    respond(['success' => false, 'message' => $conn->error], 500);
}