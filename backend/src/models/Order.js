const db = require('../config/db');

/**
 * Crea una orden con sus items en una sola transacción.
 * @param {number}   userId
 * @param {Array}    items  - [{ product_id, quantity, unit_price }]
 * @param {number}   total
 */
const create = async (userId, items, total) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    const orderResult = await client.query(
      `INSERT INTO orders (user_id, total, status)
       VALUES ($1, $2, 'pending')
       RETURNING *`,
      [userId, total]
    );
    const order = orderResult.rows[0];

    for (const item of items) {
      await client.query(
        `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
         VALUES ($1, $2, $3, $4)`,
        [order.id, item.product_id, item.quantity, item.unit_price]
      );
    }

    await client.query('COMMIT');
    return order;
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
};

/**
 * Devuelve todas las órdenes de un usuario.
 * @param {number} userId
 */
const findByUser = async (userId) => {
  const { rows } = await db.query(
    `SELECT o.id, o.status, o.total, o.created_at,
            json_agg(json_build_object(
              'product_id', oi.product_id,
              'quantity', oi.quantity,
              'unit_price', oi.unit_price
            )) AS items
     FROM orders o
     JOIN order_items oi ON oi.order_id = o.id
     WHERE o.user_id = $1
     GROUP BY o.id
     ORDER BY o.created_at DESC`,
    [userId]
  );
  return rows;
};

/**
 * Busca una orden por ID.
 * @param {number} id
 */
const findById = async (id) => {
  const { rows } = await db.query('SELECT * FROM orders WHERE id = $1', [id]);
  return rows[0] || null;
};

/**
 * Actualiza el estado de una orden.
 * @param {number} id
 * @param {string} status  - 'pending' | 'paid' | 'shipped' | 'delivered' | 'cancelled'
 */
const updateStatus = async (id, status) => {
  const { rows } = await db.query(
    'UPDATE orders SET status = $1, updated_at = NOW() WHERE id = $2 RETURNING *',
    [status, id]
  );
  return rows[0] || null;
};

module.exports = { create, findByUser, findById, updateStatus };
