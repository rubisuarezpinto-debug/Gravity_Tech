/**
 * =========================================================
 * cart.js — Lógica de UI del carrito de compras
 * =========================================================
 *
 * DESCRIPCIÓN:
 *   Este archivo gestiona la lógica en el cliente para representar
 *   los items del carrito.
 *   
 * LO QUE DEBE CONTENER:
 *   1. Lógica para renderizar los items que retorna api.getCart() en el DOM
 *      de las páginas index.html, product.html, y sobretodo cart.html.
 *   2. Funciones para manejar eventos de clicks en botones como "Agregar",
 *      "+", "-" (modificar cantidad) o "Eliminar item".
 *   3. En cada acción de UI, llamar a la función correspondiente de `api.js`
 *      (ej. api.addToCart(), api.updateCartItem(), etc.) para que el 
 *      servidor registre el cambio persistentemente en la Base de Datos.
 *   4. Actualizar dinámicamente un contador de carrito global (ej. en el header)
 *      tras cada operación.
 */
/**
 * =========================================================
 * cart.js — Lógica de UI del carrito de compras (sidebar)
 * =========================================================
 */
/**
 * =========================================================
 * cart.js — Lógica de UI del carrito de compras (sidebar)
 * =========================================================
 * Campos reales del backend:
 *   item: { id, quantity, product_id, name, price, image_url, subtotal }
 */

// ── Abrir / cerrar sidebar ────────────────────────────────
function openCart() {
  document.getElementById('cart-sidebar').classList.add('open');
  document.getElementById('cart-overlay').classList.add('open');
  renderCart();
}

function closeCart() {
  document.getElementById('cart-sidebar').classList.remove('open');
  document.getElementById('cart-overlay').classList.remove('open');
}

// ── Actualizar contador del header ────────────────────────
async function updateCartCount() {
  try {
    const { items } = await api.getCart();
    const total = items.reduce((sum, item) => sum + item.quantity, 0);
    const counter = document.getElementById('cart-count');
    if (counter) counter.textContent = total;
  } catch {
    // Sin sesión activa: mantener en 0
  }
}

// ── Renderizar items en el sidebar ────────────────────────
async function renderCart() {
  const list    = document.getElementById('cart-items-list');
  const countEl = document.getElementById('cart-item-count');
  const totalEl = document.getElementById('cart-total-price');

  list.innerHTML = '<p class="cart-empty">Cargando...</p>';

  try {
    const { items } = await api.getCart();

    if (!items || items.length === 0) {
      list.innerHTML = '<p class="cart-empty">Tu carrito está vacío.</p>';
      if (countEl) countEl.textContent = '0';
      if (totalEl) totalEl.textContent = '$ 0 COP';
      return;
    }

    list.innerHTML = '';
    let totalItems = 0;
    let totalPrice = 0;

    items.forEach(item => {
      totalItems += item.quantity;
      totalPrice += Number(item.subtotal);

      const card = document.createElement('div');
      card.classList.add('cart-item');
      card.dataset.itemId = item.id;
      card.innerHTML = `
        <img
          class="cart-item-img"
          src="${item.image_url}"
          alt="${item.name}"
          onerror="this.src='https://placehold.co/80x80/3a3a3a/00c8e0?text=IMG'"
        >
        <span class="cart-item-name">${item.name}</span>
        <span class="cart-item-price">$${formatPrice(item.subtotal)} </span>
        <span class="cart-item-stock">Precio unitario: $${formatPrice(item.price)}</span>
        <div class="cart-item-controls">
          <div class="qty-controls">
            <button class="qty-btn qty-minus" onclick='changeQuantity(${item.id}, ${item.quantity - 1})'>−</button>
            <span class="qty-value">${item.quantity}</span>
            <button class="qty-btn qty-plus" onclick='changeQuantity(${item.id}, ${item.quantity + 1})'>+</button>
          </div>
          <button class="btn-remove" onclick='removeItem(${item.id})'>🗑 Eliminar</button>
        </div>
      `;
      list.appendChild(card);
    });

    if (countEl) countEl.textContent = totalItems;
    if (totalEl) totalEl.textContent = formatPrice(totalPrice);

  } catch (err) {
    list.innerHTML = '<p class="cart-empty">Inicia sesión para ver tu carrito.</p>';
    console.error('renderCart error:', err);
  }
}

// ── Agregar al carrito ────────────────────────────────────
async function addToCart(productId) {
  if (!auth.isLoggedIn()) {
    alert('Debes iniciar sesión para agregar productos al carrito.');
    openLogin();
    return;
  }
  try {
    await api.addToCart(productId, 1);
    await updateCartCount();
    openCart();
  } catch (err) {
    console.error('addToCart error:', err);
    alert('No se pudo agregar el producto. Intenta de nuevo.');
  }
}

// ── Cambiar cantidad ──────────────────────────────────────
async function changeQuantity(itemId, newQty) {
  if (newQty < 1) {
    await removeItem(itemId);
    return;
  }
  try {
    await api.updateCartItem(itemId, { quantity: newQty });
    await updateCartCount();
    await renderCart();
  } catch (err) {
    console.error('changeQuantity error:', err);
  }
}

// ── Eliminar item ─────────────────────────────────────────
async function removeItem(itemId) {
  try {
    await api.removeCartItem(itemId);
    await updateCartCount();
    await renderCart();
  } catch (err) {
    console.error('removeItem error:', err);
  }
}

// ── Vaciar carrito ────────────────────────────────────────
async function clearCart() {
  try {
    await api.clearCart();
    await updateCartCount();
    await renderCart();
  } catch (err) {
    console.error('clearCart error:', err);
  }
}

// ── Event listeners ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('cart-close-btn')
    ?.addEventListener('click', closeCart);

  document.getElementById('cart-overlay')
    ?.addEventListener('click', closeCart);

  document.querySelector('.btn-cart')
    ?.addEventListener('click', (e) => {
      e.preventDefault();
      openCart();
    });

  document.getElementById('btn-checkout')
    ?.addEventListener('click', openCheckout);

  updateCartCount();
});