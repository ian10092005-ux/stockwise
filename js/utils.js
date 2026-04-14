const API = '../api';

// ── FETCH HELPERS ─────────────────────────────────────────────

async function apiGet(endpoint) {
    try {
        const res  = await fetch(`${API}/${endpoint}`);
        const data = await res.json();
        // If any API call returns 401, boot to login
        if (res.status === 401) {
            window.location.replace('../login.html');
            return null;
        }
        if (!data.success) throw new Error(data.message || 'API error');
        return data;
    } catch (err) {
        showToast('Error: ' + err.message, 'error');
        console.error(err);
        return null;
    }
}

async function apiPost(endpoint, body) {
    try {
        const res  = await fetch(`${API}/${endpoint}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        });
        const data = await res.json();
        return data;
    } catch (err) {
        showToast('Error: ' + err.message, 'error');
        return { success: false, message: err.message };
    }
}

async function apiPut(endpoint, body) {
    try {
        const res  = await fetch(`${API}/${endpoint}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        });
        return await res.json();
    } catch (err) {
        showToast('Error: ' + err.message, 'error');
        return { success: false, message: err.message };
    }
}

async function apiDelete(endpoint) {
    try {
        const res  = await fetch(`${API}/${endpoint}`, { method: 'DELETE' });
        return await res.json();
    } catch (err) {
        showToast('Error: ' + err.message, 'error');
        return { success: false, message: err.message };
    }
}

// ── MODAL ─────────────────────────────────────────────────────
function openModal(id)  { document.getElementById(id)?.classList.add('open');    }
function closeModal(id) { document.getElementById(id)?.classList.remove('open'); }
document.addEventListener('click', e => {
    if (e.target.classList.contains('modal-overlay')) e.target.classList.remove('open');
});

// ── TOAST ─────────────────────────────────────────────────────
function showToast(msg, type = 'success') {
    document.querySelector('.toast')?.remove();
    const colors = { success: '#0e9f6e', error: '#e02424', warn: '#d97706' };
    const t = document.createElement('div');
    t.className = 'toast';
    t.style.cssText = `position:fixed;bottom:22px;right:22px;z-index:9999;
        background:${colors[type]||colors.success};color:#fff;padding:11px 18px;
        border-radius:8px;font-size:.83rem;font-weight:600;
        box-shadow:0 4px 16px rgba(0,0,0,.15);animation:slideUp .25s ease;`;
    t.textContent = msg;
    document.body.appendChild(t);
    setTimeout(() => { t.style.opacity='0'; t.style.transition='opacity .3s'; setTimeout(()=>t.remove(),300); }, 3200);
}

// ── TABLE SEARCH ──────────────────────────────────────────────
function filterTable(inputId, tbodyId) {
    const val = document.getElementById(inputId)?.value.toLowerCase() || '';
    document.querySelectorAll('#' + tbodyId + ' tr').forEach(row => {
        row.style.display = row.textContent.toLowerCase().includes(val) ? '' : 'none';
    });
}

// ── EXPIRY BADGE ──────────────────────────────────────────────
function expiryBadge(dateStr) {
    const days = Math.round((new Date(dateStr) - new Date()) / 86400000);
    if (days < 0)   return `<span class="badge badge-danger">Expired</span>`;
    if (days <= 30)  return `<span class="badge badge-danger">${days}d left</span>`;
    if (days <= 90)  return `<span class="badge badge-warning">${days}d left</span>`;
    return `<span class="badge badge-success">${days}d left</span>`;
}

function stockBadge(status) {
    const map = {
        'Out of Stock': 'badge-danger',
        'Reorder Now':  'badge-danger',
        'Low Stock':    'badge-warning',
        'Sufficient':   'badge-success',
    };
    return `<span class="badge ${map[status] || 'badge-gray'}">${status}</span>`;
}

// Render all [data-expiry] on page load
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-expiry]').forEach(el => {
        el.innerHTML = expiryBadge(el.dataset.expiry);
    });
});

// ── FORM VALIDATION ───────────────────────────────────────────
function validateForm(formId) {
    let ok = true;
    document.querySelectorAll('#' + formId + ' [required]').forEach(el => {
        el.style.borderColor = '';
        if (!el.value.trim()) { el.style.borderColor = '#e02424'; ok = false; }
    });
    return ok;
}

// ── RECEIPT PRINT ─────────────────────────────────────────────
function printReceipt(saleData) {
    const { id, date, cashier, items, total, cash, change } = saleData;
    const rows = items.map(i =>
        `<tr><td>${i.name}${i.variant ? ' ('+i.variant+')' : ''}</td>
         <td style="text-align:center">${i.qty}</td>
         <td style="text-align:right">P${parseFloat(i.price).toFixed(2)}</td>
         <td style="text-align:right">P${(i.qty * i.price).toFixed(2)}</td></tr>`
    ).join('');
    const html = `<!DOCTYPE html><html><head><title>Receipt #${id}</title>
    <style>body{font-family:'Courier New',monospace;max-width:320px;margin:20px auto;font-size:12px}
    h2{text-align:center;font-size:16px;margin:0}p{text-align:center;margin:2px 0;font-size:11px;color:#555}
    hr{border:none;border-top:1px dashed #ccc;margin:8px 0}table{width:100%;border-collapse:collapse}
    th{font-size:10px;text-transform:uppercase;padding:4px 2px;border-bottom:1px solid #ccc}
    td{padding:3px 2px}.total-row td{font-weight:bold;border-top:1px dashed #ccc}
    .summary{width:100%;margin-top:6px}.summary td:last-child{text-align:right;font-weight:bold}
    .footer{text-align:center;margin-top:12px;font-size:10px;color:#888}</style>
    </head><body>
    <h2>StockWise</h2>
    <p>Smart Grocery Inventory &amp; Expiry Management</p>
    <p>Technological Institute of the Philippines</p>
    <hr><p>Receipt #${id} &nbsp;|&nbsp; ${date}</p><p>Cashier: ${cashier}</p><hr>
    <table><thead><tr><th>Item</th><th>Qty</th><th>Price</th><th>Subtotal</th></tr></thead>
    <tbody>${rows}</tbody></table>
    <table class="summary">
      <tr><td>Total</td><td>P${parseFloat(total).toFixed(2)}</td></tr>
      <tr><td>Cash</td><td>P${parseFloat(cash).toFixed(2)}</td></tr>
      <tr class="total-row"><td>Change</td><td>P${parseFloat(change).toFixed(2)}</td></tr>
    </table>
    <hr><div class="footer">Thank you for your purchase!</div></body></html>`;
    const win = window.open('', '_blank', 'width=380,height=600');
    win.document.write(html);
    win.document.close();
    setTimeout(() => win.print(), 400);
}

// ── CSV EXPORT ────────────────────────────────────────────────
function exportTableToCSV(tableId, filename) {
    const table = document.getElementById(tableId);
    if (!table) { showToast('Table not found.', 'error'); return; }
    const rows = [];
    const allHeaders = Array.from(table.querySelectorAll('thead th'));
    // FIX: only strip last column if it's actually labeled 'Actions'
    const lastHeader = allHeaders[allHeaders.length - 1]?.textContent.trim().toLowerCase();
    const hasActionsCol = lastHeader === 'actions';
    const headers = allHeaders.map(th => `"${th.textContent.trim()}"`);
    if (hasActionsCol) headers.pop();
    rows.push(headers.join(','));
    table.querySelectorAll('tbody tr').forEach(tr => {
        if (tr.style.display === 'none') return;
        const cells = Array.from(tr.querySelectorAll('td'));
        if (hasActionsCol) cells.pop();
        rows.push(cells.map(td => `"${td.textContent.trim().replace(/\s+/g,' ')}"`).join(','));
    });
    const blob = new Blob([rows.join('\n')], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename || 'report.csv';
    link.click();
    showToast('Exported as CSV — open in Excel.');
}

// ── LOGOUT ────────────────────────────────────────────────────
function confirmLogout() {
    if (confirm('Are you sure you want to log out?')) {
        // FIX: call server to destroy PHP session
        fetch('../api/logout.php', { method: 'POST' }).finally(() => {
            sessionStorage.clear();
            window.location.href = '../login.html';
        });
    }
}

// ── NOTIFICATIONS PANEL ───────────────────────────────────────
(function initNotifications() {
    document.addEventListener('DOMContentLoaded', () => {
        const btn = document.querySelector('.topbar-actions .icon-btn');
        if (!btn) return;

        // Cashiers don't see stock notifications — hide the bell entirely
        const role = sessionStorage.getItem('sw_role') || 'cashier';
        if (role === 'cashier') { btn.style.display = 'none'; return; }

        // Build panel
        const panel = document.createElement('div');
        panel.id = 'notifPanel';
        panel.style.cssText = `
            position:fixed;top:60px;right:18px;width:320px;
            background:#fff;border:1px solid var(--border);border-radius:12px;
            box-shadow:0 8px 32px rgba(0,0,0,.12);z-index:1000;
            display:none;flex-direction:column;overflow:hidden;`;
        panel.innerHTML = `
            <div style="padding:14px 18px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between">
              <span style="font-weight:700;font-size:.88rem">Notifications</span>
              <span id="notifClearBtn" style="font-size:.75rem;color:var(--primary);cursor:pointer;font-weight:600">Mark all read</span>
            </div>
            <div id="notifList" style="max-height:320px;overflow-y:auto;padding:8px 0">
              <div style="text-align:center;padding:32px 18px;color:var(--text-muted);font-size:.82rem">Loading…</div>
            </div>
            <div style="padding:10px 18px;border-top:1px solid var(--border);text-align:center">
              <a href="expiry.html" style="font-size:.78rem;color:var(--primary);font-weight:600;text-decoration:none">View Expiry Monitor →</a>
            </div>`;
        document.body.appendChild(panel);

        // Toggle panel on bell click
        btn.addEventListener('click', e => {
            e.stopPropagation();
            const open = panel.style.display === 'flex';
            panel.style.display = open ? 'none' : 'flex';
            if (!open) loadNotifications();
        });

        // Close on outside click
        document.addEventListener('click', e => {
            if (!panel.contains(e.target) && e.target !== btn) {
                panel.style.display = 'none';
            }
        });

        // Mark all read
        document.getElementById('notifClearBtn').addEventListener('click', () => {
            localStorage.setItem('sw_notif_read', Date.now());
            document.getElementById('notifDot') && (document.getElementById('notifDot').style.display = 'none');
            renderNotifications([]);
        });

        async function loadNotifications() {
            const list = document.getElementById('notifList');
            const lastRead = parseInt(localStorage.getItem('sw_notif_read') || '0');
            try {
                const res = await fetch('../api/dashboard.php');
                const data = await res.json();
                if (!data.success) throw new Error();
                const notifs = [];
                const { stats, restock_alerts } = data;

                if (stats.expired > 0) {
                    notifs.push({ type:'danger', icon:'⛔', text: `${stats.expired} batch${stats.expired>1?'es':''} have already expired.`, link:'expiry.html' });
                }
                if (stats.near_expiry > 0) {
                    notifs.push({ type:'warn', icon:'⚠️', text: `${stats.near_expiry} batch${stats.near_expiry>1?'es':''} expiring within 90 days.`, link:'expiry.html' });
                }
                restock_alerts.forEach(r => {
                    notifs.push({ type:'info', icon:'📦', text: `${r.product_name} is low on stock (${r.total_stock} units left).`, link:'inventory.html' });
                });

                // Show dot if there are unread notifications
                const dot = document.getElementById('notifDot');
                if (dot && notifs.length > 0 && lastRead < Date.now() - 60000) {
                    dot.style.display = 'block';
                }
                renderNotifications(notifs, lastRead);
            } catch(e) {
                list.innerHTML = `<div style="text-align:center;padding:24px;color:var(--text-muted);font-size:.82rem">Could not load notifications.</div>`;
            }
        }

        function renderNotifications(notifs, lastRead) {
            const list = document.getElementById('notifList');
            if (!notifs.length) {
                list.innerHTML = `<div style="text-align:center;padding:32px 18px;color:var(--text-muted);font-size:.82rem">🎉 All caught up! No alerts.</div>`;
                return;
            }
            const colors = { danger:'#fef2f2', warn:'#fffbeb', info:'#eff6ff' };
            const borders = { danger:'#fecaca', warn:'#fde68a', info:'#bfdbfe' };
            list.innerHTML = notifs.map(n => `
                <a href="${n.link}" style="display:flex;gap:12px;align-items:flex-start;padding:12px 18px;
                    background:${colors[n.type]||'#fff'};border-left:3px solid ${borders[n.type]||'#e2e8f0'};
                    margin:4px 8px;border-radius:8px;text-decoration:none;color:inherit;
                    transition:opacity .15s" onmouseover="this.style.opacity='.8'" onmouseout="this.style.opacity='1'">
                  <span style="font-size:1.1rem;flex-shrink:0;margin-top:1px">${n.icon}</span>
                  <span style="font-size:.8rem;line-height:1.5;color:#374151">${n.text}</span>
                </a>`).join('');
        }
    });
})();