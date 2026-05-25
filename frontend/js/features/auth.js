/**
 * =========================================================
 * auth.js — Gestión del JWT y sesión de usuario
 * =========================================================
 *
 * DESCRIPCIÓN:
 *   Este archivo se encarga de manejar el ciclo de vida de la sesión
 *   del usuario en el frontend, interactuando con el localStorage.
 *
 * LO QUE DEBE CONTENER:
 *   1. Función `setSession(token, user)`: Para guardar el JWT devuelto por el
 *      backend en el localStorage tras un login o registro exitoso.
 *   2. Función `getToken()`: Para recuperar el token (usado por api.js).
 *   3. Función `getUser()`: Para obtener los datos del usuario logueado.
 *   4. Función `isLoggedIn()`: Devuelve booleano si hay sesión activa.
 *   5. Función `isAdmin()`: Devuelve booleano si el rol del usuario es 'admin'.
 *   6. Función `logout()`: Elimina el token del localStorage y redirige al login.
 *   7. Funciones de protección de rutas como `requireAuth()` y `requireAdmin()`
 *      que verifiquen el estado en localStorage y redirijan si no se cumplen requisitos.
 *
 * NOTA DE SEGURIDAD:
 *   El frontend utiliza el JWT del localStorage solo por conveniencia
 *   para mostrar/ocultar UI. La seguridad real se valida SIEMPRE en el
 *   backend cuando el token viaja en las cabeceras HTTP de las peticiones api.js.
 */
/**
 * =========================================================
 * auth.js — Lógica de UI para modales de Login y Registro
 * =========================================================
 * Endpoints:
 *   POST /api/auth/login    → { token, user }
 *   POST /api/auth/register → { token, user }
 *   GET  /api/auth/me       → { user }
 */

/**
 * =========================================================
 * auth.js — Gestión de sesión + UI de modales Login/Registro
 * =========================================================
 */

// ════════════════════════════════════════
// GESTIÓN DE SESIÓN (localStorage)
// ════════════════════════════════════════

/**
 * Guarda el token y los datos del usuario tras login/registro exitoso.
 * @param {string} token - JWT devuelto por el backend
 * @param {object} user  - Objeto usuario devuelto por el backend
 */
function setSession(token, user) {
  localStorage.setItem('token', token);
  localStorage.setItem('user', JSON.stringify(user));
}

/**
 * Recupera el JWT almacenado. Usado por api.js en cada request.
 * @returns {string|null}
 */
function getToken() {
  return localStorage.getItem('token');
}

/**
 * Devuelve el objeto usuario guardado en localStorage.
 * @returns {object|null}
 */
function getUser() {
  try {
    return JSON.parse(localStorage.getItem('user'));
  } catch {
    return null;
  }
}

/**
 * True si hay una sesión activa (token presente).
 * @returns {boolean}
 */
function isLoggedIn() {
  return !!localStorage.getItem('token');
}

/**
 * True si el usuario tiene rol 'admin'.
 * @returns {boolean}
 */
function isAdmin() {
  const user = getUser();
  return user?.rol === 'admin';
}

/**
 * True si el usuario tiene rol 'trabajador'.
 * @returns {boolean}
 */
function isTrabajador() {
  const user = getUser();
  return user?.rol === 'trabajador';
}

/**
 * Elimina la sesión del localStorage.
 * No redirige — la redirección la maneja quien llama a logout().
 */
function logout() {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
}

/**
 * Protección de ruta: redirige al inicio si no hay sesión activa.
 * Llamar al inicio de páginas que requieren login (ej. orders.html).
 */
function requireAuth() {
  if (!isLoggedIn()) {
    openLogin();
    return false;
  }
  return true;
}

/**
 * Protección de ruta: redirige al inicio si no es admin.
 * Llamar al inicio de páginas del panel de administración.
 */
function requireAdmin() {
  if (!isLoggedIn() || !isAdmin()) {
    window.location.href = 'index.html';
    return false;
  }
  return true;
}

/**
 * Protección de ruta: redirige al inicio si no es trabajador ni admin.
 */
function requireTrabajador() {
  if (!isLoggedIn() || (!isAdmin() && !isTrabajador())) {
    window.location.href = 'index.html';
    return false;
  }
  return true;
}

// Exponer globalmente para que api.js y otros archivos lo usen
window.auth = { setSession, getToken, getUser, isLoggedIn, isAdmin, isTrabajador, logout, requireAuth, requireAdmin, requireTrabajador };


// ════════════════════════════════════════
// UI — MODALES DE LOGIN Y REGISTRO
// ════════════════════════════════════════

function openLogin() {
  window.location.href = 'login.html';
}

function closeLogin() {
  document.getElementById('login-overlay').classList.remove('open');
}

function openRegister() {
  window.location.href = 'register.html';
}

function closeRegister() {
  document.getElementById('register-overlay').classList.remove('open');
}

function clearAuthForm(type) {
  if (type === 'login') {
    document.getElementById('login-email').value = '';
    document.getElementById('login-password').value = '';
    document.getElementById('login-email').classList.remove('error');
    document.getElementById('login-password').classList.remove('error');
    showAuthError('login', '');
  } else {
    document.getElementById('register-name').value = '';
    document.getElementById('register-email').value = '';
    document.getElementById('register-password').value = '';
    ['register-name', 'register-email', 'register-password'].forEach(id =>
      document.getElementById(id).classList.remove('error')
    );
    showAuthError('register', '');
  }
}

function showAuthError(type, message) {
  const el = document.getElementById(`${type}-error`);
  if (!el) return;
  el.textContent = message;
  el.classList.toggle('visible', !!message);
}

// ── Actualizar header según estado de sesión ─────────────
function updateHeaderAuth() {
  if (typeof window.renderHeader === 'function') {
    window.renderHeader();
    return;
  }
  const btnLogin = document.getElementById('btn-login-header');
  if (!btnLogin) return;

  const user = getUser();

  if (user) {
    btnLogin.textContent = `👤 ${user.email || 'Mi cuenta'}`;
    btnLogin.onclick = (e) => {
      e.preventDefault();
      if (confirm('¿Deseas cerrar sesión?')) {
        logout();
        updateHeaderAuth();
        updateCartCount();
      }
    };
  } else {
    btnLogin.textContent = '🔐 Iniciar sesión';
    btnLogin.onclick = (e) => {
      e.preventDefault();
      openLogin();
    };
  }
}

// ── Login ─────────────────────────────────────────────────
async function handleLogin() {
  const emailEl    = document.getElementById('login-email');
  const passwordEl = document.getElementById('login-password');
  const btn        = document.getElementById('login-submit-btn');

  let valid = true;

  if (!emailEl.value.trim() || !emailEl.value.includes('@')) {
    emailEl.classList.add('error'); valid = false;
  } else {
    emailEl.classList.remove('error');
  }

  if (!passwordEl.value.trim()) {
    passwordEl.classList.add('error'); valid = false;
  } else {
    passwordEl.classList.remove('error');
  }

  if (!valid) return;

  btn.disabled    = true;
  btn.textContent = 'Iniciando sesión...';
  showAuthError('login', '');

  try {
    const data = await api.login({ email: emailEl.value.trim(), password: passwordEl.value });
    // api.login llama a setSession internamente
    if (isAdmin()) {
      window.location.href = 'admin-products.html';
      return;
    }
    if (isTrabajador()) {
      window.location.href = 'admin-products.html';
      return;
    }
    closeLogin();
    updateHeaderAuth();
    await updateCartCount();
  } catch (err) {
    showAuthError('login', err.message || 'Credenciales incorrectas.');
  } finally {
    btn.disabled    = false;
    btn.textContent = 'Iniciar Sesión';
  }
}

// ── Registro ──────────────────────────────────────────────
async function handleRegister() {
  const nameEl     = document.getElementById('register-name');
  const emailEl    = document.getElementById('register-email');
  const passwordEl = document.getElementById('register-password');
  const btn        = document.getElementById('register-submit-btn');

  let valid = true;

  if (!nameEl.value.trim()) {
    nameEl.classList.add('error'); valid = false;
  } else {
    nameEl.classList.remove('error');
  }

  if (!emailEl.value.trim() || !emailEl.value.includes('@')) {
    emailEl.classList.add('error'); valid = false;
  } else {
    emailEl.classList.remove('error');
  }

  if (passwordEl.value.length < 8) {
    passwordEl.classList.add('error'); valid = false;
  } else {
    passwordEl.classList.remove('error');
  }

  if (!valid) return;

  btn.disabled    = true;
  btn.textContent = 'Registrando...';
  showAuthError('register', '');

  try {
    await api.register({ name: nameEl.value.trim(), email: emailEl.value.trim(), password: passwordEl.value });
    closeRegister();
    updateHeaderAuth();
    await updateCartCount();
  } catch (err) {
    showAuthError('register', err.message || 'No se pudo registrar. Intenta de nuevo.');
  } finally {
    btn.disabled    = false;
    btn.textContent = 'Registrarse';
  }
}

// ── Event listeners ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('login-close-btn')
    ?.addEventListener('click', closeLogin);
  document.getElementById('register-close-btn')
    ?.addEventListener('click', closeRegister);

  document.getElementById('login-overlay')
    ?.addEventListener('click', (e) => { if (e.target.id === 'login-overlay') closeLogin(); });
  document.getElementById('register-overlay')
    ?.addEventListener('click', (e) => { if (e.target.id === 'register-overlay') closeRegister(); });

  document.getElementById('go-to-register')
    ?.addEventListener('click', () => { closeLogin(); openRegister(); });
  document.getElementById('go-to-login')
    ?.addEventListener('click', () => { closeRegister(); openLogin(); });

  // Nota: login.html y register.html manejan sus propios botones de submit
  // con onclick para evitar que se llame el handler dos veces.

  updateHeaderAuth();
});