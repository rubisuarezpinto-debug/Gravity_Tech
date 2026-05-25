/**
 * config.js — Configuración de entorno para el frontend
 *
 * Detecta automáticamente si se está ejecutando en local o en producción.
 * IMPORTANTE: Si cambias la URL de Render, actualiza RENDER_URL aquí.
 */

(function () {
  const RENDER_URL = 'https://techstore-backend-a4e2.onrender.com/api';
  const LOCAL_URL  = 'http://localhost:3000/api';

  const isLocal =
    window.location.hostname === 'localhost' ||
    window.location.hostname === '127.0.0.1';

  window.CONFIG = {
    API_URL: isLocal ? LOCAL_URL : RENDER_URL,
  };
})();
