<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole();

$type = $_GET['type'] ?? 'inventory';

if ($type === 'inventory') {
    $sql = "SELECT p.sku_code, p.name AS product_name, c.name AS category,
                   IFNULL(SUM(i.current_stock),0) AS total_stock, p.reorder_level,
                   CASE WHEN IFNULL(SUM(i.current_stock),0) = 0 THEN 'Out of Stock'
                        WHEN IFNULL(SUM(i.current_stock),0) <= p.reorder_level THEN 'Reorder Now'
                        WHEN IFNULL(SUM(i.current_stock),0) <= p.reorder_level*1.5 THEN 'Low Stock'
                        ELSE 'Sufficient' END AS stock_status
            FROM products p
            JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN inventory i ON p.product_id = i.product_id
            GROUP BY p.product_id ORDER BY c.name, p.name";
}

if ($type === 'sales') {
    $sql = "SELECT c.name AS category, COUNT(si.sale_item_id) AS items_sold,
                   SUM(si.quantity) AS units_sold,
                   ROUND(SUM(si.quantity * si.unit_price),2) AS total_revenue
            FROM sale_items si
            JOIN products p ON si.product_id = p.product_id
            JOIN categories c ON p.category_id = c.category_id
            GROUP BY c.category_id ORDER BY total_revenue DESC";
}

if ($type === 'expiry') {
    $sql = "SELECT p.name AS product_name, pv.variant_name, i.batch_number,
                   i.current_stock, i.expiration_date,
                   DATEDIFF(i.expiration_date, CURDATE()) AS days_left,
                   CASE WHEN i.expiration_date < CURDATE() THEN 'Expired'
                        WHEN i.expiration_date < DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'Expiring Soon'
                        WHEN i.expiration_date < DATE_ADD(CURDATE(), INTERVAL 90 DAY) THEN 'Near Expiry'
                        ELSE 'Good' END AS expiry_status
            FROM inventory i
            JOIN products p ON i.product_id = p.product_id
            LEFT JOIN product_variants pv ON i.variant_id = pv.variant_id
            ORDER BY i.expiration_date ASC";
}

if ($type === 'restock') {
    // contact split into contact_person + phone
    $sql = "SELECT p.name AS product_name,
                   ROUND(SUM(si.quantity) / COUNT(DISTINCT DATE_FORMAT(s.sale_date,'%Y-%m'))) AS avg_monthly_sold,
                   ROUND(SUM(si.quantity) / COUNT(DISTINCT DATE_FORMAT(s.sale_date,'%Y-%m'))) * 2 AS suggested_order_qty,
                   sup.name AS supplier,
                   sup.contact_person AS supplier_contact,
                   sup.phone AS supplier_phone
            FROM sale_items si
            JOIN sales s ON si.sale_id = s.sale_id
            JOIN products p ON si.product_id = p.product_id
            JOIN suppliers sup ON p.supplier_id = sup.supplier_id
            GROUP BY p.product_id ORDER BY avg_monthly_sold DESC";
}

if (!isset($sql)) {
    respond(['success' => false, 'message' => 'Unknown report type. Use: inventory, sales, expiry, or restock.'], 400);
}

$result = $conn->query($sql);
$rows = [];
while ($row = $result->fetch_assoc()) $rows[] = $row;
respond(['success' => true, 'type' => $type, 'data' => $rows]);