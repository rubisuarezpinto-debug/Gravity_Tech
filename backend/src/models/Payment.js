const db = require('../config/db');

/**
 * Registra un pago para una orden.
 * @param {number} orderId
 * @param {number} amount
 * @param {string} method  - 'card' | 'cash' | 'transfer'
 */
const create = async (orderId, amount, method) => {
  const { rows } = await db.query(
    `INSERT INTO ecommerce.pago (id_orden, monto, referencia, estado)
     VALUES ($1, $2, $3, 'COMPLETADO')
     RETURNING id_pago AS id, id_orden AS order_id, monto AS amount, estado AS status`,
    [orderId, amount, method]
  );
  return rows[0];
};

/**
 * Devuelve el pago asociado a una orden.
 * @param {number} orderId
 */
const findByOrder = async (orderId) => {
  const { rows } = await db.query(
    'SELECT id_pago AS id, id_orden AS order_id, monto AS amount, estado AS status FROM ecommerce.pago WHERE id_orden = $1',
    [orderId]
  );
  return rows[0] || null;
};

module.exports = { create, findByOrder };
