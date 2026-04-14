<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole();

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    if ($id) {
        $sale  = $conn->query("SELECT s.*, u.username AS cashier FROM sales s JOIN user_account u ON s.user_id=u.user_id WHERE s.sale_id=$id")->fetch_assoc();
        $items = [];
        $r = $conn->query("SELECT si.*, p.name AS product_name, pv.variant_name, si.quantity*si.unit_price AS subtotal
                           FROM sale_items si JOIN products p ON si.product_id=p.product_id
                           LEFT JOIN product_variants pv ON si.variant_id=pv.variant_id
                           WHERE si.sale_id=$id");
        while ($row = $r->fetch_assoc()) $items[] = $row;
        respond(['success' => true, 'sale' => $sale, 'items' => $items]);
    }
    $sql = "SELECT s.sale_id, s.sale_date, u.username AS cashier,
                   s.total_amount, s.cash_received,
                   (s.cash_received - s.total_amount) AS change_amount,
                   COUNT(si.sale_item_id) AS item_count
            FROM sales s
            JOIN user_account u ON s.user_id = u.user_id
            LEFT JOIN sale_items si ON s.sale_id = si.sale_id
            GROUP BY s.sale_id ORDER BY s.sale_date DESC";
    $result = $conn->query($sql);
    $rows   = [];
    while ($row = $result->fetch_assoc()) $rows[] = $row;
    respond(['success' => true, 'data' => $rows, 'count' => count($rows)]);
}

if ($method === 'POST') {
    requireRole(['admin', 'cashier']);
    $input   = json_decode(file_get_contents('php://input'), true);
    $user_id = (int)currentUserId();
    $total   = (float)($input['total_amount']  ?? 0);
    $cash    = (float)($input['cash_received'] ?? 0);
    $items   = $input['items'] ?? [];
    if (!$total || !$cash || empty($items)) respond(['success' => false, 'message' => 'Total, cash, and items are required.'], 400);
    if ($cash < $total) respond(['success' => false, 'message' => 'Cash received is less than total.'], 400);
    if (!$user_id) respond(['success' => false, 'message' => 'Session expired. Please log in again.'], 401);

    $conn->begin_transaction();
    try {
        $conn->query("INSERT INTO sales (user_id, total_amount, cash_received) VALUES ($user_id, $total, $cash)");
        $sale_id = $conn->insert_id;

        foreach ($items as $item) {
            $pid   = (int)($item['product_id'] ?? 0);
            $vid   = !empty($item['variant_id']) ? (int)$item['variant_id'] : 'NULL';
            $qty   = (int)($item['quantity']    ?? 0);
            $price = (float)($item['unit_price'] ?? 0);

            // ── Guard: check stock for this specific product+variant ──
            $variantFilter = ($vid === 'NULL') ? "AND variant_id IS NULL" : "AND variant_id=$vid";
            $availRow = $conn->query("SELECT IFNULL(SUM(current_stock),0) AS avail
                                      FROM inventory
                                      WHERE product_id=$pid
                                        $variantFilter
                                        AND current_stock > 0
                                        AND (delivery_date IS NULL OR delivery_date <= CURDATE())")->fetch_assoc();
            $available = (int)$availRow['avail'];
            if ($qty > $available) {
                $conn->rollback();
                $productName = $conn->query("SELECT name FROM products WHERE product_id=$pid")->fetch_assoc()['name'] ?? "Product #$pid";
                $variantLabel = '';
                if ($vid !== 'NULL') {
                    $vRow = $conn->query("SELECT variant_name FROM product_variants WHERE variant_id=$vid")->fetch_assoc();
                    if ($vRow) $variantLabel = ' (' . $vRow['variant_name'] . ')';
                }
                respond(['success' => false, 'message' => "Insufficient stock for \"$productName$variantLabel\". Requested: $qty, Available: $available."], 400);
            }

            $conn->query("INSERT INTO sale_items (sale_id, product_id, variant_id, quantity, unit_price)
                          VALUES ($sale_id, $pid, $vid, $qty, $price)");

            // Deduct from batches FIFO (oldest expiry first), variant-aware
            $remaining = $qty;
            $batches = $conn->query("SELECT inventory_id, current_stock, batch_number FROM inventory
                                     WHERE product_id=$pid
                                       $variantFilter
                                       AND current_stock > 0
                                       AND (delivery_date IS NULL OR delivery_date <= CURDATE())
                                     ORDER BY expiration_date ASC");
            while ($batch = $batches->fetch_assoc()) {
                if ($remaining <= 0) break;
                $inv_id      = (int)$batch['inventory_id'];
                $batchStock  = (int)$batch['current_stock'];
                $batchNoEsc  = $conn->real_escape_string($batch['batch_number']);
                $deduct      = min($remaining, $batchStock);

                $conn->query("UPDATE inventory SET current_stock=current_stock-$deduct WHERE inventory_id=$inv_id");
                $conn->query("INSERT INTO stock_movements (inventory_id, product_id, variant_id, user_id, type, quantity_change, remarks)
                              VALUES ($inv_id, $pid, $vid, $user_id, 'OUT', $deduct, 'Sale ID $sale_id')");
                $remaining -= $deduct;

                // If this deduction drained the batch, log DEPLETED and hard-delete it
                if (($batchStock - $deduct) <= 0) {
                    $conn->query("INSERT INTO stock_movements (inventory_id, product_id, variant_id, user_id, type, quantity_change, remarks)
                                  VALUES ($inv_id, $pid, $vid, $user_id, 'DEPLETED', 0, 'Batch $batchNoEsc fully depleted — auto-removed')");
                    $conn->query("UPDATE stock_movements SET inventory_id = NULL WHERE inventory_id = $inv_id");
                    $conn->query("DELETE FROM inventory WHERE inventory_id = $inv_id");
                }
            }
        }

        $conn->commit();
        respond(['success' => true, 'message' => 'Sale recorded.', 'sale_id' => $sale_id], 201);
    } catch (Exception $e) {
        $conn->rollback();
        respond(['success' => false, 'message' => 'Sale failed: ' . $e->getMessage()], 500);
    }
}