/**
 * =========================================================
 * orders-admin.js — Lógica del modal de historial de órdenes
 * =========================================================
 * Solo accesible para administradores.
 * Endpoint: GET /api/admin/orders → { orders: [...] }
 *
 * Estructura esperada de cada orden:
 * {
 *   id, total, created_at,
 *   user: { name, email },
 *   items: [{ name, quantity, unit_price }]
 * }
 */

// Cache de órdenes para filtrado local sin re-fetch
let _allOrders = [];

// ── Abrir / cerrar modal ──────────────────────────────────
function openOrdersPanel() {
  if (!auth.requireAdmin()) return;
  document.getElementById('orders-overlay').classList.add('open');
  loadAllOrders();
}

function closeOrdersPanel() {
  document.getElementById('orders-overlay').classList.remove('open');
}

// ── Cargar todas las órdenes ──────────────────────────────
async function loadAllOrders() {
  const listEl = document.getElementById('orders-list');
  listEl.innerHTML = '<p class="orders-empty">Cargando órdenes...</p>';
  resetStats();

  try {
    const { orders } = await api.getAllOrders();
    _allOrders = orders || [];
    renderStats(_allOrders);
    renderOrders(_allOrders);
  } catch (err) {
    listEl.innerHTML = '<p class="orders-empty">Error al cargar las órdenes.</p>';
    console.error('loadAllOrders error:', err);
  }
}

// ── Renderizar estadísticas ───────────────────────────────
function renderStats(orders) {
  const totalOrders   = orders.length;
  const totalProducts = orders.reduce((sum, o) => {
    const items = o.items || o.order_items || [];
    return sum + items.reduce((s, i) => s + (i.quantity || 0), 0);
  }, 0);
  const totalSales = orders.reduce((sum, o) => sum + Number(o.total || 0), 0);

  document.getElementById('stat-total-orders').textContent   = totalOrders;
  document.getElementById('stat-total-products').textContent = totalProducts;
  document.getElementById('stat-total-sales').textContent    =
    `$${totalSales.toLocaleString('es-CO')}`;
}

function resetStats() {
  document.getElementById('stat-total-orders').textContent   = '—';
  document.getElementById('stat-total-products').textContent = '—';
  document.getElementById('stat-total-sales').textContent    = '—';
}

// ── Renderizar lista de órdenes ───────────────────────────
function renderOrders(orders) {
  const listEl = document.getElementById('orders-list');

  if (!orders.length) {
    listEl.innerHTML = '<p class="orders-empty">No se encontraron órdenes.</p>';
    return;
  }

  listEl.innerHTML = '';

  orders.forEach(order => {
    const items    = order.items || order.order_items || [];
    const user     = order.user  || {};
    const shortId  = String(order.id).slice(0, 8);
    const date     = order.created_at
      ? new Date(order.created_at).toLocaleString('es-CO', {
          year: 'numeric', month: 'long', day: 'numeric',
          hour: '2-digit', minute: '2-digit'
        })
      : '—';

    const card = document.createElement('div');
    card.classList.add('order-card');

    card.innerHTML = `
      <!-- Header -->
      <div class="order-header">
        <div>
          <div class="order-id">Orden #${shortId}</div>
          <div class="order-date">${date}</div>
        </div>
        <div>
          <div class="order-total-label">Total</div>
          <div class="order-total">$${Number(order.total).toLocaleString('es-CO')}</div>
        </div>
      </div>

      <!-- Cliente -->
      <div class="order-customer">
        <div class="customer-block">
          <span class="customer-icon">👤</span>
          <div>
            <div class="customer-name">${user.name || 'Usuario'}</div>
            <div class="customer-email">${user.email || '—'}</div>
          </div>
        </div>
        <div class="customer-block">
          <span class="customer-icon">📍</span>
          <div class="customer-name">${order.shipping_address || '—'}</div>
        </div>
      </div>

      <!-- Productos -->
      <div class="order-products">
        <div class="products-title">Productos (${items.length})</div>
        ${items.map(item => `
          <div class="order-product-row">
            <span>${item.name || item.product_name || '—'}</span>
            <span class="product-qty">x${item.quantity}</span>
            <span class="product-subtotal">
              $${(Number(item.unit_price || item.precio_unitario || 0) * item.quantity).toLocaleString('es-CO')}
            </span>
          </div>
        `).join('')}
      </div>
    `;

    listEl.appendChild(card);
  });
}

// ── Filtrar por email ─────────────────────────────────────
function filterOrdersByEmail() {
  const query = document.getElementById('orders-search-input').value.trim().toLowerCase();
  if (!query) {
    renderOrders(_allOrders);
    renderStats(_allOrders);
    return;
  }

  const filtered = _allOrders.filter(o => {
    const email = (o.user?.email || '').toLowerCase();
    return email.includes(query);
  });

  renderStats(filtered);
  renderOrders(filtered);
}

// ── Event listeners ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('orders-close-btn')
    ?.addEventListener('click', closeOrdersPanel);

  document.getElementById('orders-overlay')
    ?.addEventListener('click', (e) => {
      if (e.target.id === 'orders-overlay') closeOrdersPanel();
    });

  document.getElementById('btn-orders-search')
    ?.addEventListener('click', filterOrdersByEmail);

  document.getElementById('orders-search-input')
    ?.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') filterOrdersByEmail();
    });

  document.getElementById('btn-orders-all')
    ?.addEventListener('click', () => {
      document.getElementById('orders-search-input').value = '';
      renderStats(_allOrders);
      renderOrders(_allOrders);
    });

  // Botón "Pedidos" del header admin
  document.querySelector('a[href="admin-orders.html"]')
    ?.addEventListener('click', (e) => {
      e.preventDefault();
      openOrdersPanel();
    });
});