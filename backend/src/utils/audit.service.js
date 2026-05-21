const db = require('../config/db');

/**
 * Registra una acción en la tabla de auditoría.
 * @param {number|null} idUsuario ID del usuario que realiza la acción (puede ser null si no está autenticado)
 * @param {string} accion Nombre de la acción realizada (ej: 'LOGIN', 'CREATE_PRODUCT')
 * @param {string} entidad Nombre de la tabla/entidad afectada (ej: 'usuario', 'producto')
 * @param {string} detalle Descripción de la acción para fines de depuración/historial
 */
const registrarAccion = async (idUsuario, accion, entidad, detalle) => {
  try {
    await db.query(
      `INSERT INTO ecommerce.auditoria (id_usuario, accion, entidad, detalle)
       VALUES ($1, $2, $3, $4)`,
      [idUsuario, accion, entidad, detalle]
    );
    console.log(`[AUDIT] Acción: ${accion} | Entidad: ${entidad} | Usuario: ${idUsuario}`);
  } catch (err) {
    console.error('[AUDIT ERROR] No se pudo registrar la acción de auditoría:', err.message);
  }
};

module.exports = { registrarAccion };
