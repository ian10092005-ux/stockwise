// ============================================================
//  StockWise — Sidebar with Role-Based Navigation
//  js/sidebar.js
//
//  Role visibility rules:
//    admin         → sees everything
//    stock_manager → dashboard, inventory, products, expiry, suppliers, reports
//    cashier       → dashboard, products (read-only view), expiry, sales
// ============================================================

(function () {
    const page = window.location.pathname.split('/').pop().replace('.html', '');
    const role = sessionStorage.getItem('sw_role')     || 'cashier';
    const name = sessionStorage.getItem('sw_username') || '—';

    // Which pages each role is allowed to visit
    const access = {
        admin:         ['dashboard','inventory','products','expiry','sales','suppliers','reports','settings','management'],
        stock_manager: ['dashboard','inventory','products','expiry','suppliers','settings'],
        cashier:       ['dashboard','sales','settings'],
    };

    const allowed = access[role] || access.cashier;

    // Redirect away if this page is not allowed for the role
    if (page !== '' && !allowed.includes(page)) {
        window.location.href = 'dashboard.html';
        return;
    }

    const navItems = [
        { id: 'dashboard', label: 'Dashboard',      icon: Icons.dashboard, href: 'dashboard.html',  section: 'main'         },
        { id: 'inventory',  label: 'Inventory',      icon: Icons.inventory,  href: 'inventory.html',  section: 'main'         },
        { id: 'products',   label: 'Products',       icon: Icons.products,   href: 'products.html',   section: 'main'         },
        { id: 'expiry',     label: 'Expiry Monitor', icon: Icons.expiry,     href: 'expiry.html',     section: 'main'         },
        { id: 'sales',      label: 'Sales',          icon: Icons.sales,      href: 'sales.html',      section: 'transactions' },
        { id: 'suppliers',  label: 'Suppliers',      icon: Icons.suppliers,  href: 'suppliers.html',  section: 'transactions' },
        { id: 'reports',    label: 'Reports',        icon: Icons.reports,    href: 'reports.html',    section: 'system'       },
        { id: 'settings',   label: 'Settings',       icon: Icons.settings,   href: 'settings.html',   section: 'system'       },
        { id: 'management', label: 'System Management', icon: Icons.management, href: 'management.html', section: 'system'       },
    ];

    const roleLabels = {
        admin:         'Administrator',
        stock_manager: 'Stock Manager',
        cashier:       'Cashier'
    };

    function buildSection(sectionId) {
        return navItems
            .filter(item => item.section === sectionId && allowed.includes(item.id))
            .map(item => {
                const active = page === item.id ? ' active' : '';
                return `<a class="nav-link${active}" href="${item.href}">${item.icon}${item.label}</a>`;
            }).join('');
    }

    const mainLinks        = buildSection('main');
    const transactionLinks = buildSection('transactions');
    const systemLinks      = buildSection('system');

    const html = `
    <aside class="sidebar" id="appSidebar">
      <div class="sidebar-logo">
        <div class="logo-icon">${Icons.logo}</div>
        <span class="logo-text">Stock<span>Wise</span></span>
      </div>

      <nav class="sidebar-nav">
        ${mainLinks        ? `<div class="nav-label">Main</div>${mainLinks}` : ''}
        ${transactionLinks ? `<div class="nav-label">Transactions</div>${transactionLinks}` : ''}
        ${systemLinks      ? `<div class="nav-label">System</div>${systemLinks}` : ''}
      </nav>

      <div class="sidebar-footer">
        <div class="user-row">
          <div class="user-avatar">${Icons.user}</div>
          <div class="user-meta">
            <div class="user-name">${name}</div>
            <div class="user-role">${roleLabels[role] || role}</div>
          </div>
          <button class="logout-btn" onclick="confirmLogout()" title="Log out">${Icons.logout}</button>
        </div>
      </div>
    </aside>`;

    document.body.insertAdjacentHTML('afterbegin', html);
})();

function confirmLogout() {
    if (confirm('Are you sure you want to log out?')) {
        // FIX: call server to destroy PHP session, not just clear sessionStorage
        fetch('../api/logout.php', { method: 'POST' }).finally(() => {
            sessionStorage.clear();
            window.location.href = '../login.html';
        });
    }
}