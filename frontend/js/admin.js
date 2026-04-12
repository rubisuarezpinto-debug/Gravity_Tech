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
  document.getElementById('admin-brand').value       = '';
  document.getElementById('admin-description').value = '';
  document.getElementById('admin-stock').value       = '';
  document.getElementById('admin-price').value       = '';
  document.getElementById('admin-image')?.value      = '';

  ['admin-title', 'admin-category', 'admin-brand', 'admin-stock', 'admin-price'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.classList.remove('error');
  });

  showAdminError('');

  document.getElementById('btn-admin-cancel')?.remove();

  // Restablecer botón a modo "Crear"
  const btn = document.getElementById('btn-admin-create');
  if (btn) {
    btn.textContent      = 'Crear';
    btn.dataset.editId   = '';
    btn.dataset.editMode = 'false';
  }
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
  if (!listEl) return;

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
      item.dataset.product = JSON.stringify(p);
      item.innerHTML = `
        <div class="item-info">
          <span class="item-name">${p.name}</span>
          <span class="item-meta">Cat. ${p.id_categoria || p.category_id} — $${Number(p.price).toLocaleString('es-CO')}</span>
        </div>
        <span class="item-stock">Stock: ${p.stock}</span>
        <div class="item-actions">
          <button class="btn-item-edit" title="Editar">✏️</button>
          <button class="btn-item-img" title="Actualizar imagen">🖼️</button>
          <button class="btn-item-delete" title="Eliminar">🗑️</button>
        </div>
      `;

      item.querySelector('.btn-item-edit').addEventListener('click', () => {
        fillEditForm(JSON.parse(item.dataset.product));
      });

      item.querySelector('.btn-item-img').addEventListener('click', () => {
        updateProductImage(p.id, p.image_url || '');
      });

      item.querySelector('.btn-item-delete').addEventListener('click', () => {
        deleteProduct(p.id, p.name);
      });

      listEl.appendChild(item);
    });

  } catch (err) {
    listEl.innerHTML = '<p class="admin-list-empty">Error al cargar productos.</p>';
    console.error('loadAdminProducts error:', err);
  }
}

async function updateProductImage(productId, currentUrl) {
  const newUrl = prompt('URL de la imagen:', currentUrl);
  if (newUrl === null) return; // canceló

  try {
    await api.updateProductImage(productId, newUrl);
    await loadAdminProducts();
  } catch (err) {
    alert('Error al actualizar la imagen: ' + err.message);
  }
}

// ── Rellenar formulario para editar ──────────────────────
function fillEditForm(product) {
  document.getElementById('admin-title').value       = product.name        || '';
  document.getElementById('admin-category').value    = product.category_id || product.id_categoria || '';
  document.getElementById('admin-brand').value       = product.brand_id    || product.id_marca || '';
  document.getElementById('admin-description').value = product.description || '';
  document.getElementById('admin-stock').value       = product.stock       || '';
  document.getElementById('admin-price').value       = product.price       || '';
  
  const imgEl = document.getElementById('admin-image');
  if (imgEl) imgEl.value = product.image_url || '';

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

  document.querySelector('.admin-form-col')?.scrollIntoView({ behavior: 'smooth' });
}

// ── Validar formulario ────────────────────────────────────
function validateAdminForm() {
  const required = [
    { id: 'admin-title',    label: 'Título' },
    { id: 'admin-category', label: 'Categoría' },
    { id: 'admin-brand',    label: 'Marca' },
    { id: 'admin-stock',    label: 'Stock' },
    { id: 'admin-price',    label: 'Precio' },
  ];

  let valid = true;
  required.forEach(({ id, label }) => {
    const el = document.getElementById(id);
    if (!el || !el.value.trim()) {
      if (el) el.classList.add('error');
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
    brand_id:    Number(document.getElementById('admin-brand').value),
    description: document.getElementById('admin-description').value.trim(),
    stock:       Number(document.getElementById('admin-stock').value),
    price:       Number(document.getElementById('admin-price').value),
    image_url:   document.getElementById('admin-image')?.value.trim() || null,
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
  }
}

// ── Event listeners ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('btn-admin-create')?.addEventListener('click', submitAdminForm);
  document.getElementById('admin-close-btn')?.addEventListener('click', closeAdminPanel);
  
  if (document.getElementById('admin-products-list') && !document.getElementById('admin-overlay')) {
    if (auth.requireAdmin()) {
      loadAdminProducts();
    }
  }

  document.getElementById('admin-overlay')?.addEventListener('click', (e) => {
    if (e.target.id === 'admin-overlay') closeAdminPanel();
  });
});