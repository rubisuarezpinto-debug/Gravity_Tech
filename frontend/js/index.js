/**
 * =========================================================
 * index.js — Lógica de la página principal (Home)
 * =========================================================
 */

async function loadProducts(filters = {}) {
  const container = document.getElementById('products-container');
  if (!container) return;

  const isAdmin = auth.isAdmin();
  container.innerHTML = '<p style="color:var(--text-muted);padding:var(--spacing-lg)">Cargando productos...</p>';

  try {
    const { products } = await api.getProducts();

    let filtered = products;

    if (filters.search && filters.search.trim()) {
      const q = filters.search.trim().toLowerCase();
      filtered = filtered.filter(p =>
        p.name.toLowerCase().includes(q) ||
        p.description?.toLowerCase().includes(q)
      );
    }

    if (filters.category) {
      filtered = filtered.filter(p =>
        (p.category || '').toLowerCase() === filters.category.toLowerCase()
      );
    }

    if (filters.price === 'low') filtered = filtered.filter(p => p.price < 1000000);
    if (filters.price === 'mid') filtered = filtered.filter(p => p.price >= 1000000 && p.price <= 3000000);
    if (filters.price === 'high') filtered = filtered.filter(p => p.price > 3000000);

    container.innerHTML = '';

    if (!filtered.length) {
      container.innerHTML = '<p style="color:var(--text-muted);padding:var(--spacing-lg)">No se encontraron productos.</p>';
      return;
    }

    filtered.forEach(product => {
      const card = document.createElement('section');
      card.classList.add('product');
      
      // Botón condicional según rol
      const actionBtn = isAdmin
        ? `<a href="admin-products.html" class="btn-admin-card" style="text-decoration:none; display:inline-block; margin-top:10px; background:var(--accent-blue); color:white; padding:8px 15px; border-radius:5px">⚙ Administrar</a>`
        : `<button class='btn-add-cart' onclick='addToCart(${product.id})'>🛒 Agregar al carrito</button>`;
      
      const stockClass = product.stock < 5 ? 'stock-low' : product.stock < 20 ? 'stock-mid' : '';

      card.innerHTML = `
        <a href="product.html?id=${product.id}" class="product-link">
          <div class="product-img-wrapper">
            <img
              src="${product.image_url}"
              alt="${product.name}"
              onerror="this.src='https://placehold.co/300x225/3a3a3a/00c8e0?text=Sin+imagen'"
            >
          </div>
          <h2>${product.name}</h2>
          <p>${product.description || ''}</p>
        </a>
        <div class="product-meta">
          <span class="badge-stock ${stockClass}">${product.stock} disponibles</span>
        </div>
        <span class="price">${formatPrice(product.price)}</span>
        ${actionBtn}
      `;
      container.appendChild(card);
    });

  } catch (err) {
    container.innerHTML = '<p style="color:var(--text-muted);padding:var(--spacing-lg)">Error al cargar productos.</p>';
    console.error('Error cargando productos:', err);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // Cargar productos al inicio
  loadProducts();

  // Listeners para búsqueda y filtros
  const runSearch = () => loadProducts({
    search:   document.getElementById('search-input').value,
    price:    document.getElementById('filter-price').value,
    category: document.getElementById('filter-category').value,
  });

  document.getElementById('search-btn')?.addEventListener('click', runSearch);
  document.getElementById('search-input')?.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') runSearch();
  });

  document.getElementById('show-all-btn')?.addEventListener('click', () => {
    const searchInput = document.getElementById('search-input');
    const categorySelect = document.getElementById('filter-category');
    const priceSelect = document.getElementById('filter-price');
    
    if (searchInput) searchInput.value = '';
    if (categorySelect) categorySelect.value = '';
    if (priceSelect) priceSelect.value = '';
    
    loadProducts();
  });

  document.getElementById('filter-price')?.addEventListener('change', () => {
    loadProducts({
      search:   document.getElementById('search-input')?.value || '',
      price:    document.getElementById('filter-price').value,
      category: document.getElementById('filter-category')?.value || '',
    });
  });

  document.getElementById('filter-category')?.addEventListener('change', () => {
    loadProducts({
      search:   document.getElementById('search-input')?.value || '',
      price:    document.getElementById('filter-price')?.value || '',
      category: document.getElementById('filter-category').value,
    });
  });
});
