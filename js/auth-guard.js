(function () {
    // 1. Hide page immediately to prevent flash of content
    document.documentElement.style.visibility = 'hidden';

    // 2. Role → allowed pages map (filename without path)
    const PAGE_ACCESS = {
        admin:         ['dashboard.html', 'inventory.html', 'products.html',
                        'suppliers.html', 'sales.html', 'reports.html',
                        'expiry.html', 'settings.html', 'management.html'],
        stock_manager: ['dashboard.html', 'inventory.html', 'products.html',
                        'suppliers.html', 'reports.html', 'expiry.html', 'settings.html'],
        cashier:       ['dashboard.html', 'sales.html', 'settings.html'],
    };

    // 3. Get current page filename
    const currentPage = window.location.pathname.split('/').pop();

    // 4. Check session then enforce access
    fetch('../api/session.php')
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (!data.success) {
                // Not logged in → go to login
                window.location.replace('../login.html');
                return;
            }

            const role = data.role;
            const allowed = PAGE_ACCESS[role] || [];

            if (!allowed.includes(currentPage)) {
                // Logged in but wrong role for this page → go to dashboard
                window.location.replace('dashboard.html');
                return;
            }

            // Authorised — store session info for other scripts to use
            window.__sw_user = { userId: data.user_id, username: data.username, role: role };
            // Also store in sessionStorage so sidebar.js can read the role
            sessionStorage.setItem('sw_role',     role);
            sessionStorage.setItem('sw_username', data.username);

            // Show the page
            document.documentElement.style.visibility = '';
        })
        .catch(function () {
            // Network error — redirect to login to be safe
            window.location.replace('../login.html');
        });
})();