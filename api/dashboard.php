<?php

require_once '../includes/headers.php';
require_once '../includes/auth.php';
require_once '../includes/db.php';

requireRole();

$uid  = (int)currentUserId();
$role = currentRole();

// ── CASHIER DASHBOARD ────────────────────────────────────────
if ($role === 'cashier') {
    $today_total = $conn->query("SELECT IFNULL(SUM(total_amount),0) AS total FROM sales
        WHERE user_id=$uid AND DATE(sale_date)=CURDATE()")->fetch_assoc()['total'];

    $today_count = $conn->query("SELECT COUNT(*) AS cnt FROM sales
        WHERE user_id=$uid AND DATE(sale_date)=CURDATE()")->fetch_assoc()['cnt'];

    $month_total = $conn->query("SELECT IFNULL(SUM(total_amount),0) AS total FROM sales
        WHERE user_id=$uid
          AND MONTH(sale_date)=MONTH(CURDATE())
          AND YEAR(sale_date)=YEAR(CURDATE())")->fetch_assoc()['total'];

    $trend_result = $conn->query("SELECT DATE(sale_date) AS day, ROUND(SUM(total_amount),2) AS revenue
        FROM sales
        WHERE user_id=$uid AND DATE(sale_date) >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
        GROUP BY DATE(sale_date) ORDER BY day ASC");
    $trend_map = [];
    while ($row = $trend_result->fetch_assoc()) $trend_map[$row['day']] = (float)$row['revenue'];
    $trend = [];
    for ($i = 6; $i >= 0; $i--) {
        $day = date('Y-m-d', strtotime("-$i days"));
        $trend[] = ['day' => $day, 'revenue' => $trend_map[$day] ?? 0];
    }

    $recent_result = $conn->query("SELECT sale_id, sale_date, total_amount, cash_received,
        (cash_received - total_amount) AS change_amount
        FROM sales WHERE user_id=$uid
        ORDER BY sale_date DESC LIMIT 10");
    $recent = [];
    while ($row = $recent_result->fetch_assoc()) $recent[] = $row;

    respond([
        'success' => true,
        'role'    => 'cashier',
        'stats'   => [
            'today_total' => (float)$today_total,
            'today_count' => (int)$today_count,
            'month_total' => (float)$month_total,
        ],
        'sales_trend'         => $trend,
        'recent_transactions' => $recent,
    ]);
}

// ── STOCK MANAGER DASHBOARD ──────────────────────────────────
if ($role === 'stock_manager') {
    $total_stock = $conn->query("SELECT IFNULL(SUM(current_stock),0) AS cnt FROM inventory")->fetch_assoc()['cnt'];

    $near_expiry = $conn->query("SELECT COUNT(*) AS cnt FROM inventory
        WHERE expiration_date <= DATE_ADD(CURDATE(), INTERVAL 90 DAY)
        AND expiration_date >= CURDATE()")->fetch_assoc()['cnt'];

    $expired = $conn->query("SELECT COUNT(*) AS cnt FROM inventory
        WHERE expiration_date < CURDATE() AND current_stock > 0")->fetch_assoc()['cnt'];

    $restock_count = $conn->query("SELECT COUNT(*) AS cnt FROM (
        SELECT p.product_id, p.reorder_level, IFNULL(SUM(i.current_stock),0) AS total_stock
        FROM products p LEFT JOIN inventory i ON p.product_id=i.product_id
        GROUP BY p.product_id, p.reorder_level
        HAVING total_stock <= p.reorder_level) AS sub")->fetch_assoc()['cnt'];

    $top_result = $conn->query("SELECT p.name AS product_name, SUM(si.quantity) AS total_sold
        FROM sale_items si JOIN products p ON si.product_id=p.product_id
        GROUP BY p.product_id ORDER BY total_sold DESC LIMIT 5");
    $top_sellers = [];
    while ($row = $top_result->fetch_assoc()) $top_sellers[] = $row;

    $alert_result = $conn->query("SELECT p.name AS product_name, p.sku_code, p.reorder_level,
        IFNULL(SUM(i.current_stock),0) AS total_stock,
        s.name AS supplier, s.contact_person AS supplier_contact, s.phone AS supplier_phone,
        CASE
            WHEN IFNULL(SUM(i.current_stock),0)=0                THEN 'Out of Stock'
            WHEN IFNULL(SUM(i.current_stock),0)<=p.reorder_level THEN 'Reorder Now'
            ELSE 'Low Stock'
        END AS stock_status
        FROM products p JOIN suppliers s ON p.supplier_id=s.supplier_id
        LEFT JOIN inventory i ON p.product_id=i.product_id
        GROUP BY p.product_id
        HAVING total_stock <= p.reorder_level * 1.5
        ORDER BY total_stock ASC");
    $alerts = [];
    while ($row = $alert_result->fetch_assoc()) $alerts[] = $row;

    $upcoming_result = $conn->query("SELECT i.batch_number, p.name AS product_name, p.sku_code,
        i.current_stock AS incoming_qty, i.delivery_date,
        DATEDIFF(i.delivery_date, CURDATE()) AS days_until_delivery, s.name AS supplier
        FROM inventory i JOIN products p ON i.product_id=p.product_id
        JOIN suppliers s ON p.supplier_id=s.supplier_id
        WHERE i.delivery_date > CURDATE() ORDER BY i.delivery_date ASC LIMIT 10");
    $upcoming = [];
    while ($row = $upcoming_result->fetch_assoc()) $upcoming[] = $row;

    respond([
        'success' => true,
        'role'    => 'stock_manager',
        'stats'   => [
            'total_stock'    => (int)$total_stock,
            'near_expiry'    => (int)$near_expiry,
            'expired'        => (int)$expired,
            'restock_alerts' => (int)$restock_count,
        ],
        'top_sellers'         => $top_sellers,
        'restock_alerts'      => $alerts,
        'upcoming_deliveries' => $upcoming,
    ]);
}

// ── ADMIN DASHBOARD ──────────────────────────────────────────
$total_products  = $conn->query("SELECT COUNT(*) AS cnt FROM products")->fetch_assoc()['cnt'];
$total_stock     = $conn->query("SELECT IFNULL(SUM(current_stock),0) AS cnt FROM inventory")->fetch_assoc()['cnt'];
$near_expiry     = $conn->query("SELECT COUNT(*) AS cnt FROM inventory
    WHERE expiration_date <= DATE_ADD(CURDATE(), INTERVAL 90 DAY)
    AND expiration_date >= CURDATE()")->fetch_assoc()['cnt'];
$expired         = $conn->query("SELECT COUNT(*) AS cnt FROM inventory
    WHERE expiration_date < CURDATE() AND current_stock > 0")->fetch_assoc()['cnt'];
$monthly_revenue = $conn->query("SELECT IFNULL(SUM(total_amount),0) AS total FROM sales
    WHERE MONTH(sale_date)=MONTH(CURDATE()) AND YEAR(sale_date)=YEAR(CURDATE())")->fetch_assoc()['total'];
$restock_count   = $conn->query("SELECT COUNT(*) AS cnt FROM (
    SELECT p.product_id, p.reorder_level, IFNULL(SUM(i.current_stock),0) AS total_stock
    FROM products p LEFT JOIN inventory i ON p.product_id=i.product_id
    GROUP BY p.product_id, p.reorder_level
    HAVING total_stock <= p.reorder_level) AS sub")->fetch_assoc()['cnt'];

$trend_result = $conn->query("SELECT DATE(sale_date) AS day, ROUND(SUM(total_amount),2) AS revenue
    FROM sales WHERE DATE(sale_date) >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
    GROUP BY DATE(sale_date) ORDER BY day ASC");
$trend_map = [];
while ($row = $trend_result->fetch_assoc()) $trend_map[$row['day']] = (float)$row['revenue'];
$trend = [];
for ($i = 6; $i >= 0; $i--) {
    $day = date('Y-m-d', strtotime("-$i days"));
    $trend[] = ['day' => $day, 'revenue' => $trend_map[$day] ?? 0];
}

$cat_result = $conn->query("SELECT c.name AS category, IFNULL(SUM(i.current_stock),0) AS total_stock
    FROM categories c LEFT JOIN products p ON c.category_id=p.category_id
    LEFT JOIN inventory i ON p.product_id=i.product_id
    GROUP BY c.category_id HAVING total_stock>0 ORDER BY total_stock DESC");
$by_category = [];
while ($row = $cat_result->fetch_assoc()) $by_category[] = $row;

$top_result = $conn->query("SELECT p.name AS product_name, SUM(si.quantity) AS total_sold
    FROM sale_items si JOIN products p ON si.product_id=p.product_id
    GROUP BY p.product_id ORDER BY total_sold DESC LIMIT 5");
$top_sellers = [];
while ($row = $top_result->fetch_assoc()) $top_sellers[] = $row;

$alert_result = $conn->query("SELECT p.name AS product_name, p.sku_code, p.reorder_level,
    IFNULL(SUM(i.current_stock),0) AS total_stock,
    s.name AS supplier, s.contact_person AS supplier_contact, s.phone AS supplier_phone,
    CASE
        WHEN IFNULL(SUM(i.current_stock),0)=0                THEN 'Out of Stock'
        WHEN IFNULL(SUM(i.current_stock),0)<=p.reorder_level THEN 'Reorder Now'
        ELSE 'Low Stock'
    END AS stock_status
    FROM products p JOIN suppliers s ON p.supplier_id=s.supplier_id
    LEFT JOIN inventory i ON p.product_id=i.product_id
    GROUP BY p.product_id HAVING total_stock <= p.reorder_level * 1.5
    ORDER BY total_stock ASC");
$alerts = [];
while ($row = $alert_result->fetch_assoc()) $alerts[] = $row;

$upcoming_result = $conn->query("SELECT i.batch_number, p.name AS product_name, p.sku_code,
    i.current_stock AS incoming_qty, i.delivery_date,
    DATEDIFF(i.delivery_date, CURDATE()) AS days_until_delivery, s.name AS supplier
    FROM inventory i JOIN products p ON i.product_id=p.product_id
    JOIN suppliers s ON p.supplier_id=s.supplier_id
    WHERE i.delivery_date > CURDATE() ORDER BY i.delivery_date ASC LIMIT 10");
$upcoming_deliveries = [];
while ($row = $upcoming_result->fetch_assoc()) $upcoming_deliveries[] = $row;

respond([
    'success' => true,
    'role'    => 'admin',
    'stats'   => [
        'total_products'  => (int)$total_products,
        'total_stock'     => (int)$total_stock,
        'near_expiry'     => (int)$near_expiry,
        'expired'         => (int)$expired,
        'monthly_revenue' => (float)$monthly_revenue,
        'restock_alerts'  => (int)$restock_count,
    ],
    'sales_trend'         => $trend,
    'by_category'         => $by_category,
    'top_sellers'         => $top_sellers,
    'restock_alerts'      => $alerts,
    'upcoming_deliveries' => $upcoming_deliveries,
]);