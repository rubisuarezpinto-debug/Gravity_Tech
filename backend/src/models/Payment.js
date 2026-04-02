const db = require('../config/db');

/**
 * Registra un pago para una orden.
 * @param {number} orderId
 * @param {number} amount
 * @param {string} method  - 'card' | 'cash' | 'transfer'
 */
const create = async (orderId, amount, method) => {
  const { rows } = await db.query(
    `INSERT INTO payments (order_id, amount, method, status)
     VALUES ($1, $2, $3, 'completed')
     RETURNING *`,
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
    'SELECT * FROM payments WHERE order_id = $1',
    [orderId]
  );
  return rows[0] || null;
};

module.exports = { create, findByOrder };
