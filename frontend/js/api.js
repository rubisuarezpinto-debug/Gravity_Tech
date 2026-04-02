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
