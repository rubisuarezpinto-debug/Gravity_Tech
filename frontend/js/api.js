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

/**
 * =========================================================
 * api.js — Capa de comunicación con el backend
 * =========================================================
 * Depende de auth.js para manejo de token y sesión.
 * auth.js debe cargarse ANTES que este archivo.
 */

const BASE_URL = 'http://localhost:3000/api';

// ── Helper: headers con JWT ───────────────────────────────
function authHeaders() {
  const token = auth.getToken();
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  return headers;
}

// ── Helper: fetch centralizado ────────────────────────────
async function request(method, path, body = null) {
  const options = { method, headers: authHeaders() };
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
const api = {
  /** POST /api/auth/register → guarda sesión automáticamente */
  register: async (data) => {
    const result = await request('POST', '/auth/register', data);
    if (result.data?.token) auth.setSession(result.data.token, result.data.user);
    return result;
  },

  /** POST /api/auth/login → guarda sesión automáticamente */
  login: async (data) => {
    const result = await request('POST', '/auth/login', data);
    if (result.data?.token) auth.setSession(result.data.token, result.data.user);
    return result;
  },

  /** GET /api/auth/me */
  me: () => request('GET', '/auth/me'),

  // ════════════════════════════════════════
  // PRODUCTOS
  // ════════════════════════════════════════

  /** GET /api/products */
  getProducts: () => request('GET', '/products'),

  /** GET /api/products/:id */
  getProduct: (id) => request('GET', `/products/${id}`),

  // ════════════════════════════════════════
  // CARRITO
  // ════════════════════════════════════════

  /** GET /api/cart */
  getCart: () => request('GET', '/cart'),

  /** POST /api/cart — body: { product_id, quantity } */
  addToCart: (product_id, quantity = 1) =>
    request('POST', '/cart', { product_id, quantity }),

  /** PUT /api/cart/:itemId — body: { quantity } */
  updateCartItem: (itemId, { quantity }) =>
    request('PUT', `/cart/${itemId}`, { quantity }),

  /** DELETE /api/cart/:itemId */
  removeCartItem: (itemId) => request('DELETE', `/cart/${itemId}`),

  /** DELETE /api/cart */
  clearCart: () => request('DELETE', '/cart'),

  // ════════════════════════════════════════
  // ÓRDENES
  // ════════════════════════════════════════

  /** POST /api/orders/checkout — body: { payment_method } */
  createOrder: ({ payment_method }) =>
    request('POST', '/orders/checkout', { payment_method }),

  /** GET /api/orders */
  getMyOrders: () => request('GET', '/orders'),

  /** GET /api/orders/:id */
  getOrder: (id) => request('GET', `/orders/${id}`),
  
  // ════════════════════════════════════════
  // ADMIN — Órdenes
  // ════════════════════════════════════════
 
  /** GET /api/admin/orders */
  getAllOrders: () => request('GET', '/admin/orders'),
 
  /** PATCH /api/admin/orders/:id/status */
  updateOrderStatus: (id, status) =>
    request('PATCH', `/admin/orders/${id}/status`, { status }),

  // ════════════════════════════════════════
  // ADMIN — Productos
  // ════════════════════════════════════════

  /** POST /api/products (admin) */
  createProduct: (data) => request('POST', '/products', data),

  /** PUT /api/products/:id (admin) */
  updateProduct: (id, data) => request('PUT', `/products/${id}`, data),

  /** PUT /api/products/:id/image (admin) — solo actualiza imagen */
  updateProductImage: (id, image_url) =>
  request('PUT', `/products/${id}/image`, { image_url }),

  /** DELETE /api/products/:id (admin) */
  deleteProduct: (id) => request('DELETE', `/products/${id}`),

  // ════════════════════════════════════════
  // RESEÑAS
  // ════════════════════════════════════════

  /** GET /api/reviews/product/:productId — público */
  getReviews: (productId) => request('GET', `/reviews/product/${productId}`),

  /** POST /api/reviews/product/:productId — requiere JWT
   *  body: { comentario, puntuacion }
   */
  createReview: (productId, { comentario, puntuacion }) =>
    request('POST', `/reviews/product/${productId}`, { comentario, puntuacion }),

  /** DELETE /api/reviews/:id — requiere JWT */
  deleteReview: (id) => request('DELETE', `/reviews/${id}`),

};

window.api = api;