/**
 * =========================================================
 * utils.js — Utilidades y helpers frontend
 * =========================================================
 *
 * DESCRIPCIÓN:
 *   Archivo global para funciones que se repiten con frecuencia
 *   en el desarrollo de interfaces y lógica UI.
 *
 * LO QUE DEBE CONTENER:
 *   1. Formateadores (currency formatter para COP, datetime formatter).
 *   2. Sistema centralizado para mostrar notificaciones de error o éxito
 *      del tipo showAlert(mensaje, type).
 *   3. Parseo de parámetros de la URL (para leer parámetros query).
 *   4. Formateadores o truncadores de strings.
 */
/**
 * =========================================================
 * utils.js — Funciones de utilidad reutilizables
 * =========================================================
 */

function getProductIdFromURL() {
  const params = new URLSearchParams(window.location.search);
  return params.get('id');
}

function renderStars(rating) {
  let html = '<div class="stars">';
  for (let i = 1; i <= 5; i++) {
    if (i <= Math.floor(rating)) {
      html += '<span class="star filled">★</span>';
    } else if (i - rating < 1 && i - rating > 0) {
      html += '<span class="star half">★</span>';
    } else {
      html += '<span class="star">★</span>';
    }
  }
  return html + '</div>';
}

function formatPrice(price) {
  return `${Number(price).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
}