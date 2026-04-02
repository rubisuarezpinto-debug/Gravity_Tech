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
