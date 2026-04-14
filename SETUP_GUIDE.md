# StockWise — Setup Guide (Updated)
## XAMPP + Visual Studio Code + PHP Backend

---

## HOW THE DATABASE CONNECTION ACTUALLY WORKS

This is the most important thing to understand before setting up:

```
Browser (HTML / JS)
     |
     | fetch('api/products.php')   ← JS calls a PHP file via HTTP
     ↓
  Apache (XAMPP)                   ← Apache receives the request
     |
     | runs the PHP file
     ↓
  PHP (api/products.php)           ← PHP queries MySQL
     |
     | mysqli_query(...)
     ↓
  MySQL (XAMPP)                    ← MySQL returns rows
     |
     | returns data
     ↑
  PHP sends JSON back              ← PHP encodes result as JSON
     ↑
Browser receives JSON              ← JS reads JSON and renders HTML
```

**JavaScript CANNOT connect to MySQL directly.**
JS in the browser can only make HTTP requests (fetch).
PHP receives those requests, runs the SQL, and sends back JSON.
This is why XAMPP needs BOTH Apache and MySQL running — not just MySQL.

---

## FOLDER STRUCTURE (Final)

```
StockWise/                        ← Place this inside C:\xampp\htdocs\
├── login.html                    ← Entry point — uses api/login.php
├── stockwise.sql                 ← Import this into phpMyAdmin
├── SETUP_GUIDE.md
│
├── api/                          ← PHP files — talk to MySQL
│   ├── login.php                 ← POST: authenticate user
│   ├── products.php              ← GET/POST/PUT/DELETE: products CRUD
│   ├── inventory.php             ← GET/POST/PUT/DELETE: inventory CRUD
│   ├── suppliers.php             ← GET/POST/PUT/DELETE: suppliers CRUD
│   ├── sales.php                 ← GET/POST: sales transactions
│   ├── dashboard.php             ← GET: all dashboard stats
│   ├── reports.php               ← GET ?type=inventory|sales|expiry|restock
│   ├── categories.php            ← GET: category list for dropdowns
│   └── brands.php                ← GET: brand list for dropdowns
│
├── includes/                     ← Shared PHP config
│   ├── db.php                    ← MySQL connection (edit credentials here)
│   └── headers.php               ← CORS and JSON response headers
│
├── css/
│   └── style.css
│
├── js/
│   ├── icons.js                  ← All SVG icons as JS strings
│   ├── sidebar.js                ← Auto-renders sidebar on every page
│   └── utils.js                  ← fetch() helpers, toast, modal, export
│
└── pages/                        ← HTML pages — call api/ via fetch()
    ├── dashboard.html
    ├── inventory.html
    ├── products.html             ← Fully connected to database
    ├── expiry.html
    ├── sales.html
    ├── suppliers.html
    ├── reports.html
    └── settings.html
```

---

## STEP 1 — Install Required Software

1. Download **XAMPP** from https://www.apachefriends.org
   - During install, check: **Apache**, **MySQL**, **PHP**
   - Default install path: `C:\xampp\`

2. Download **Visual Studio Code** from https://code.visualstudio.com

3. Install these VS Code extensions (Ctrl+Shift+X):
   - **Live Server** — preview HTML files (for layout work only)
   - **PHP Intelephense** — PHP syntax highlighting and autocomplete
   - **Prettier** — code formatter

---

## STEP 2 — Place the Project in XAMPP

1. Extract the `StockWise` folder
2. Move it to: `C:\xampp\htdocs\StockWise\`
3. Final path must be exactly: `C:\xampp\htdocs\StockWise\login.html`

---

## STEP 3 — Start XAMPP Services

1. Open **XAMPP Control Panel**
2. Click **Start** next to **Apache** — must show green
3. Click **Start** next to **MySQL** — must show green
4. Both must be running before you open the website

---

## STEP 4 — Import the Database

1. Open browser → go to `http://localhost/phpmyadmin`
2. Click **Import** tab at the top menu
3. Click **Choose File** → select `stockwise.sql` from your project folder
4. Scroll down → click **Go**
5. Wait for success message
6. In the left sidebar you should now see **StockWise** with all 12 tables

---

## STEP 5 — Verify the Database Connection

Open this URL in your browser:
```
http://localhost/StockWise/api/products.php
```

You should see a JSON response like:
```json
{
  "success": true,
  "data": [ { "product_id": 1, "name": "White Bread Loaf", ... }, ... ],
  "count": 50
}
```

If you see this — the PHP-to-MySQL connection is working.

If you see an error — check Step 6 for troubleshooting.

---

## STEP 6 — Check/Edit Database Credentials

Open `includes/db.php` in VS Code:

```php
define('DB_HOST', 'localhost');  // Always localhost for XAMPP
define('DB_USER', 'root');       // Default XAMPP username
define('DB_PASS', '');           // Default XAMPP password — empty string
define('DB_NAME', 'StockWise');  // Must match what you named the DB
```

The defaults work for a standard XAMPP install. If you set a MySQL root password,
change `DB_PASS` to match.

---

## STEP 7 — Open the Website

Go to: `http://localhost/StockWise/login.html`

**Test accounts** (from the SQL sample data):

| Username | Password | Role |
|---|---|---|
| administrator01 | Admin@PJ2025 | Admin |
| stock_manager01 | Stock@Ian2025 | Stock Manager |
| cashier01       | Cash@Shele2025 | Cashier |

> Note: These are the raw values stored in `password_hash`. In a real production
> system you would use PHP's `password_hash()` and `password_verify()` functions.
> The login.php file has a comment showing exactly how to switch to proper hashing.

---

## STEP 8 — Open in VS Code

1. Open VS Code → **File > Open Folder**
2. Select `C:\xampp\htdocs\StockWise`
3. You can edit any PHP or HTML file and save — changes take effect immediately
   because Apache serves the files directly from that folder

> Do NOT use Live Server to open PHP files — Live Server is just for HTML preview.
> Always use `http://localhost/StockWise/` for the real site because that goes
> through Apache and PHP works properly.

---

## STEP 9 — Verify Everything Works

Run these checks in your browser:

| URL | Expected result |
|---|---|
| `http://localhost/StockWise/api/products.php` | JSON with 50 products |
| `http://localhost/StockWise/api/inventory.php` | JSON with 55 batches and expiry status |
| `http://localhost/StockWise/api/dashboard.php` | JSON with stats, chart data, alerts |
| `http://localhost/StockWise/api/suppliers.php` | JSON with 10 suppliers |
| `http://localhost/StockWise/login.html` | Login page loads |

---

## HOW JS TALKS TO PHP — Code Example

In `pages/products.html`, this is how data loads from the database:

```javascript
// js/utils.js — generic fetch helper
async function apiGet(endpoint) {
    const res  = await fetch(`../api/${endpoint}`);  // calls PHP file
    const data = await res.json();                   // PHP returns JSON
    return data;
}

// In products.html — load and render products
async function loadProducts() {
    const res = await apiGet('products.php');        // → GET api/products.php
    renderTable(res.data);                           // render the rows
}
```

In `api/products.php`, PHP handles it:

```php
// PHP queries MySQL and returns JSON
$result = $conn->query("SELECT p.*, c.name AS category ... FROM products p JOIN ...");
while ($row = $result->fetch_assoc()) $rows[] = $row;
echo json_encode(['success' => true, 'data' => $rows]);
```

This is the complete loop:
**HTML page → fetch() → PHP file → MySQL → PHP sends JSON → JS renders table**

---

## TROUBLESHOOTING

| Problem | Solution |
|---|---|
| "Could not reach server" on login | XAMPP Apache is not running. Start it. |
| phpMyAdmin shows connection error | XAMPP MySQL is not running. Start it. |
| Port 80 conflict | In XAMPP config, change Apache to port 8080. Use `http://localhost:8080/StockWise/` |
| Empty tables on pages | Check browser console (F12 → Console) for red errors |
| api/products.php shows blank page | PHP error — open `http://localhost/StockWise/api/products.php` directly to see the error |
| "Database connection failed" | Check `includes/db.php` credentials match your XAMPP setup |
| Sidebar not rendering | Make sure `icons.js` loads BEFORE `sidebar.js` in every page |
| Icons not showing | All icons are inline SVG in `icons.js` — no image files needed |
