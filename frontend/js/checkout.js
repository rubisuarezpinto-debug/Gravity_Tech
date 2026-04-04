/**
 * =========================================================
 * checkout.js — Lógica del modal de finalización de compra
 * =========================================================
 * El backend solo espera: { payment_method }
 * POST /api/orders/checkout
 */

// ── Abrir modal ───────────────────────────────────────────
async function openCheckout() {
  closeCart();
  await renderCheckoutSummary();
  document.getElementById('checkout-overlay').classList.add('open');
}

// ── Cerrar modal ──────────────────────────────────────────
function closeCheckout() {
  document.getElementById('checkout-overlay').classList.remove('open');
}

// ── Renderizar resumen del pedido ─────────────────────────
async function renderCheckoutSummary() {
  const listEl   = document.getElementById('checkout-items-list');
  const totalEl  = document.getElementById('checkout-total');
  const btnTotal = document.getElementById('checkout-btn-total');
  const emailEl  = document.getElementById('checkout-user-email');

  listEl.innerHTML = '';

  try {
    const { items } = await api.getCart();
    let total = 0;

    items.forEach(item => {
      total += Number(item.subtotal);

      const row = document.createElement('div');
      row.classList.add('checkout-order-item');
      row.innerHTML = `
        <span>${item.name}</span>
        <span class="item-qty">x${item.quantity}</span>
        <span class="item-subtotal">$${Number(item.subtotal).toLocaleString('es-CO')}</span>
      `;
      listEl.appendChild(row);
    });

    const formatted = `$ ${total.toLocaleString('es-CO')}`;
    if (totalEl)  totalEl.textContent  = formatted;
    if (btnTotal) btnTotal.textContent = `$${total.toLocaleString('es-CO')}`;

  } catch (err) {
    listEl.innerHTML = '<p style="color:var(--text-muted);font-size:13px;">Error al cargar el resumen.</p>';
    console.error('renderCheckoutSummary error:', err);
  }

  // Email del usuario autenticado
  const user = auth.getUser();
  if (emailEl) {
    emailEl.textContent = user?.email
      ? `Compra asociada a: ${user.email}`
      : 'Compra asociada a: (inicia sesión)';
  }
}

// ── Habilitar campo de referencia según método ────────────
function setupPaymentField() {
  const select    = document.getElementById('checkout-payment');
  const dataInput = document.getElementById('checkout-payment-data');
  if (!select || !dataInput) return;

  select.addEventListener('change', () => {
    const method = select.value;
    if (method === 'card') {
      dataInput.disabled    = false;
      dataInput.placeholder = 'Número de tarjeta';
    } else if (method === 'transfer') {
      dataInput.disabled    = false;
      dataInput.placeholder = 'Número de cuenta';
    } else if (method === 'cash') {
      dataInput.disabled    = true;
      dataInput.placeholder = 'No requerido';
      dataInput.value       = '';
    } else {
      dataInput.disabled    = true;
      dataInput.placeholder = 'Número tarjeta';
      dataInput.value       = '';
    }
  });
}

// ── Confirmar compra ──────────────────────────────────────
async function confirmPurchase() {
  const paymentSelect = document.getElementById('checkout-payment');

  if (!paymentSelect.value) {
    alert('Selecciona un método de pago.');
    paymentSelect.focus();
    return;
  }

  const btn = document.getElementById('btn-confirm-purchase');
  btn.disabled    = true;
  btn.textContent = 'Procesando...';

  try {
    await api.createOrder({ payment_method: paymentSelect.value });
    await updateCartCount();
    closeCheckout();
    alert('¡Compra realizada con éxito! Recibirás un correo de confirmación.');
  } catch (err) {
    console.error('confirmPurchase error:', err);
    alert('Ocurrió un error al procesar tu compra. Intenta de nuevo.');
  } finally {
    btn.disabled = false;
    // Restaurar texto del botón con el total actualizado
    const total = document.getElementById('checkout-btn-total')?.textContent || '$0';
    btn.textContent = `Confirmar compra - ${total}`;
  }
}

// ── Event listeners ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // Cerrar al hacer clic fuera del modal
  document.getElementById('checkout-overlay')
    ?.addEventListener('click', (e) => {
      if (e.target.id === 'checkout-overlay') closeCheckout();
    });

  document.getElementById('btn-confirm-purchase')
    ?.addEventListener('click', confirmPurchase);

  setupPaymentField();
});