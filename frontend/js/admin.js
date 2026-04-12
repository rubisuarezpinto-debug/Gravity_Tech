/**
 * =========================================================
 * admin.js — Lógica del panel de administrador
 * =========================================================
 * Endpoints usados:
 *   GET    /api/products          → listar productos
 *   POST   /api/products          → crear producto (admin)
 *   PUT    /api/products/:id      → editar producto (admin)
 *   DELETE /api/products/:id      → eliminar producto (admin)
 */

// ── Abrir / cerrar modal ──────────────────────────────────
function openAdminPanel() {
  if (!auth.requireAdmin()) return;
  document.getElementById('admin-overlay').classList.add('open');
  loadAdminProducts();
  clearAdminForm();
}

function closeAdminPanel() {
  const overlay = document.getElementById('admin-overlay');
  if (overlay) overlay.classList.remove('open');
  else window.location.href = 'index.html';
}

// ── Limpiar formulario ────────────────────────────────────
function clearAdminForm() {
  document.getElementById('admin-title').value       = '';
  document.getElementById('admin-category').value    = '';
  document.getElementById('admin-description').value = '';
  document.getElementById('admin-stock').value       = '';
  document.getElementById('admin-price').value       = '';
  document.getElementById('admin-image').value       = '';

  ['admin-title', 'admin-category', 'admin-stock', 'admin-price'].forEach(id =>
    document.getElementById(id).classList.remove('error')
  );

  showAdminError('');

  document.getElementById('btn-admin-cancel')?.remove();

  // Restablecer botón a modo "Crear"
  const btn = document.getElementById('btn-admin-create');
  btn.textContent      = 'Crear';
  btn.dataset.editId   = '';
  btn.dataset.editMode = 'false';
}

// ── Mostrar error ─────────────────────────────────────────
function showAdminError(message) {
  const el = document.getElementById('admin-form-error');
  if (!el) return;
  el.textContent = message;
  el.classList.toggle('visible', !!message);
}

// ── Cargar lista de productos ─────────────────────────────
async function loadAdminProducts() {
  const listEl   = document.getElementById('admin-products-list');
  const countEl  = document.getElementById('admin-product-count');
  listEl.innerHTML = '<p class="admin-list-empty">Cargando...</p>';

  try {
    const { products } = await api.getProducts();

    if (countEl) countEl.textContent = `(${products.length})`;

    if (!products.length) {
      listEl.innerHTML = '<p class="admin-list-empty">No hay productos aún.</p>';
      return;
    }

    listEl.innerHTML = '';
    products.forEach(p => {
      const item = document.createElement('div');
      item.classList.add('admin-product-item');
      item.innerHTML = `
        <div class="item-info">
          <span class="item-name">${p.name}</span>
          <span class="item-meta">Cat. ${p.category_id} — $${Number(p.price).toLocaleString('es-CO')}</span>
        </div>
        <span class="item-stock">Stock: ${p.stock}</span>
        <div class="item-actions">
          <button class="btn-item-edit" title="Editar" onclick='fillEditForm(${JSON.stringify(p)})'>✏️</button>
          <button class="btn-item-delete" title="Eliminar" onclick='deleteProduct(${p.id}, "${p.name}")'>🗑️</button>
        </div>
      `;
      listEl.appendChild(item);
    });

  } catch (err) {
    listEl.innerHTML = '<p class="admin-list-empty">Error al cargar productos.</p>';
    console.error('loadAdminProducts error:', err);
  }
}

// ── Rellenar formulario para editar ──────────────────────
function fillEditForm(product) {
  document.getElementById('admin-title').value       = product.name        || '';
  document.getElementById('admin-category').value    = product.category_id || '';
  document.getElementById('admin-description').value = product.description || '';
  document.getElementById('admin-stock').value       = product.stock       || '';
  document.getElementById('admin-price').value       = product.price       || '';
  document.getElementById('admin-image').value       = product.image_url   || '';

  const btn = document.getElementById('btn-admin-create');
  btn.textContent      = 'Actualizar';
  btn.dataset.editId   = product.id;
  btn.dataset.editMode = 'true';

  if (!document.getElementById('btn-admin-cancel')) {
    const cancelBtn = document.createElement('button');
    cancelBtn.id          = 'btn-admin-cancel';
    cancelBtn.textContent = 'Cancelar';
    cancelBtn.className   = 'btn-admin-cancel';
    cancelBtn.onclick     = clearAdminForm;
    btn.insertAdjacentElement('afterend', cancelBtn);
  }

  // Scroll al formulario en móvil
  document.querySelector('.admin-form-col')?.scrollIntoView({ behavior: 'smooth' });
}

// ── Validar formulario ────────────────────────────────────
function validateAdminForm() {
  const required = [
    { id: 'admin-title',    label: 'Título' },
    { id: 'admin-category', label: 'Categoría' },
    { id: 'admin-stock',    label: 'Stock' },
    { id: 'admin-price',    label: 'Precio' },
  ];

  let valid = true;
  required.forEach(({ id, label }) => {
    const el = document.getElementById(id);
    if (!el.value.trim()) {
      el.classList.add('error');
      valid = false;
    } else {
      el.classList.remove('error');
    }
  });

  if (!valid) showAdminError('Completa los campos obligatorios.');
  return valid;
}

// ── Crear o actualizar producto ───────────────────────────
async function submitAdminForm() {
  if (!validateAdminForm()) return;

  const btn      = document.getElementById('btn-admin-create');
  const editMode = btn.dataset.editMode === 'true';
  const editId   = btn.dataset.editId;

  const data = {
    name:        document.getElementById('admin-title').value.trim(),
    category_id: Number(document.getElementById('admin-category').value),
    description: document.getElementById('admin-description').value.trim(),
    stock:       Number(document.getElementById('admin-stock').value),
    price:       Number(document.getElementById('admin-price').value),
    image_url:   document.getElementById('admin-image').value.trim() || null,
  };

  btn.disabled    = true;
  btn.textContent = editMode ? 'Guardando...' : 'Creando...';
  showAdminError('');

  try {
    if (editMode) {
      await api.updateProduct(editId, data);
    } else {
      await api.createProduct(data);
    }

    clearAdminForm();
    await loadAdminProducts();
    // Refrescar catálogo visible
    if (typeof loadProducts === 'function') loadProducts();

  } catch (err) {
    showAdminError(err.message || 'Error al guardar el producto.');
    console.error('submitAdminForm error:', err);
  } finally {
    btn.disabled    = false;
    btn.textContent = editMode ? 'Actualizar' : 'Crear';
  }
}

// ── Eliminar producto ─────────────────────────────────────
async function deleteProduct(productId, productName) {
  if (!confirm(`¿Eliminar "${productName}"? Esta acción no se puede deshacer.`)) return;

  try {
    await api.deleteProduct(productId);
    await loadAdminProducts();
    if (typeof loadProducts === 'function') loadProducts();
  } catch (err) {
    alert('Error al eliminar el producto: ' + (err.message || ''));
    console.error('deleteProduct error:', err);
  }
}

// ── Event listeners ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // Botones de acción
  document.getElementById('btn-admin-create')?.addEventListener('click', submitAdminForm);
  document.getElementById('admin-close-btn')?.addEventListener('click', closeAdminPanel);
  
  // Iniciar automáticamente si estamos en la página de administración (no modal)
  if (document.getElementById('admin-products-list') && !document.getElementById('admin-overlay')) {
    if (auth.requireAdmin()) {
      loadAdminProducts();
    }
  }
});