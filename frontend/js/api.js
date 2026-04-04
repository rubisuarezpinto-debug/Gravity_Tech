/**
 * =========================================================
 * api.js — Capa de comunicación con el backend
 * =========================================================
 *
 * DESCRIPCIÓN:
 *   Este archivo debe centralizar TODAS las peticiones (fetch) hacia el backend.
 *   Su propósito es evitar que la lógica de fetch (con URLs, headers, etc.)
 *   esté repetida por todo el código.
 *
 * LO QUE DEBE CONTENER:
 *   1. Una constante con la URL base del backend (ej. const BASE_URL = 'http://localhost:3000/api';).
 *   2. Una función genérica `request(endpoint, options)` que:
 *      - Obtenga el JWT del localStorage usando auth.getToken().
 *      - Añada automáticamente el header 'Authorization: Bearer <token>' si hay sesión activa.
 *      - Añada el header 'Content-Type: application/json' si es necesario.
 *      - Realice el fetch y parsee la respuesta a JSON.
 *      - Lance un error (throw) si la respuesta no es OK (status 4xx o 5xx).
 *   3. Funciones específicas exportadas u organizadas en un objeto (ej. `const api = { ... }`)
 *      que envuelvan la llamada a la función genérica `request`. Por ejemplo:
 *      - login: (data) => request('/auth/login', { method: 'POST', body: JSON.stringify(data) })
 *      - getProducts: () => request('/products', { method: 'GET' })
 *      - addToCart: (data) => request('/cart', { method: 'POST', body: JSON.stringify(data) })
 *
 * CÓMO CONECTAR EL FRONTEND CON EL BACKEND Y LA BASE DE DATOS:
 *   Frontend (HTML/JS)
 *      |
 *      V  <-- (Llama a funciones de api.js)
 *   api.js (fetch)
 *      |
 *      V  <-- (Petición HTTP a http://localhost:3000/api/...)
 *   Backend (app.js -> routes/ -> controllers/)
 *      |
 *      V  <-- (Lógica de negocio y llamada a modelos)
 *   Backend (models/*.js)
 *      |
 *      V  <-- (Queries SQL usando el módulo pg y la conexión de config/db.js)
 *   Base de Datos PostgreSQL (Ejecutándose en local o Docker)
 */
/**
 * =========================================================
 * api.js — Capa de comunicación con el backend
 * =========================================================
 * Base URL: http://localhost:3000/api
 * Auth: JWT almacenado en localStorage bajo la clave 'token'
 */

const BASE_URL = 'http://localhost:3000/api';

// ── Helper: headers con JWT si existe ────────────────────
function authHeaders() {
  const token = localStorage.getItem('token');
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  return headers;
}

// ── Helper: fetch con manejo de errores centralizado ─────
async function request(method, path, body = null) {
  const options = {
    method,
    headers: authHeaders(),
  };
  if (body) options.body = JSON.stringify(body);

  const res = await fetch(`${BASE_URL}${path}`, options);

  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.message || `Error ${res.status}`);
  }

  return res.json();
}

// ════════════════════════════════════════
// AUTH
// ════════════════════════════════════════

const auth = {
  /** POST /api/auth/register */
  register: (data) => request('POST', '/auth/register', data),

  /** POST /api/auth/login → guarda el token automáticamente */
  login: async ({ email, password }) => {
    const data = await request('POST', '/auth/login', { email, password });
    if (data.token) localStorage.setItem('token', data.token);
    return data;
  },

  /** GET /api/auth/me → devuelve el usuario autenticado */
  me: () => request('GET', '/auth/me'),

  /** Cierra sesión eliminando el token */
  logout: () => localStorage.removeItem('token'),

  /** Devuelve el payload del JWT sin llamar al servidor */
  getUser: () => {
    const token = localStorage.getItem('token');
    if (!token) return null;
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return payload;
    } catch {
      return null;
    }
  },

  /** True si hay token válido */
  isLoggedIn: () => !!localStorage.getItem('token'),
};

// ════════════════════════════════════════
// PRODUCTOS
// ════════════════════════════════════════

const api = {
  /** GET /api/products → { products: [...] } */
  getProducts: () => request('GET', '/products'),

  /** GET /api/products/:id → { product: {...} } */
  getProduct: (id) => request('GET', `/products/${id}`),

  // ════════════════════════════════════════
  // CARRITO  (requieren JWT)
  // ════════════════════════════════════════

  /**
   * GET /api/cart
   * Devuelve: { items: [{ id, quantity, product_id, name, price, image_url, subtotal }] }
   */
  getCart: () => request('GET', '/cart'),

  /**
   * POST /api/cart
   * Body: { product_id, quantity }
   */
  addToCart: (product_id, quantity = 1) =>
    request('POST', '/cart', { product_id, quantity }),

  /**
   * PUT /api/cart/:itemId
   * Body: { quantity }
   */
  updateCartItem: (itemId, { quantity }) =>
    request('PUT', `/cart/${itemId}`, { quantity }),

  /**
   * DELETE /api/cart/:itemId
   */
  removeCartItem: (itemId) => request('DELETE', `/cart/${itemId}`),

  /**
   * DELETE /api/cart
   */
  clearCart: () => request('DELETE', '/cart'),

  // ════════════════════════════════════════
  // ÓRDENES  (requieren JWT)
  // ════════════════════════════════════════

  /**
   * POST /api/orders/checkout
   * Body: { payment_method }
   * Crea la orden, registra el pago y vacía el carrito.
   */
  createOrder: ({ payment_method }) =>
    request('POST', '/orders/checkout', { payment_method }),

  /** GET /api/orders → { orders: [...] } */
  getMyOrders: () => request('GET', '/orders'),

  /** GET /api/orders/:id → { order: {...} } */
  getOrder: (id) => request('GET', `/orders/${id}`),
};

// Exponer globalmente
window.api  = api;
window.auth = auth;