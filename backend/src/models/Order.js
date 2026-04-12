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

    // Suponemos id_direccion, id_metodo_pago, id_tipo_envio fijos por ahora o pasados por req
    const orderResult = await client.query(
      `INSERT INTO ecommerce.orden (id_usuario, id_direccion, id_metodo_pago, id_tipo_envio, id_estado, total)
       VALUES ($1, 1, 1, 1, (SELECT id_estado FROM ecommerce.estado_orden WHERE nombre ILIKE 'PENDIENTE' LIMIT 1), $2)
       RETURNING id_orden AS id, total, id_estado, fecha_orden AS created_at`,
      [userId, total]
    );
    const order = orderResult.rows[0];

    for (const item of items) {
      await client.query(
        `INSERT INTO ecommerce.orden_item (id_orden, id_producto, cantidad, precio_unitario)
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
    `SELECT o.id_orden AS id, s.nombre AS status, o.total, o.fecha_orden AS created_at,
            json_agg(json_build_object(
              'product_id', oi.id_producto,
              'quantity', oi.cantidad,
              'unit_price', oi.precio_unitario
            )) AS items
     FROM ecommerce.orden o
     JOIN ecommerce.orden_item oi ON oi.id_orden = o.id_orden
     JOIN ecommerce.estado_orden s ON s.id_estado = o.id_estado
     WHERE o.id_usuario = $1
     GROUP BY o.id_orden, s.nombre
     ORDER BY o.fecha_orden DESC`,
    [userId]
  );
  return rows;
};

/**
 * Busca una orden por ID.
 * @param {number} id
 */
const findById = async (id) => {
  const { rows } = await db.query(
    `SELECT o.id_orden AS id, s.nombre AS status, o.total, o.fecha_orden AS created_at
     FROM ecommerce.orden o
     JOIN ecommerce.estado_orden s ON s.id_estado = o.id_estado
     WHERE o.id_orden = $1`, 
    [id]
  );
  return rows[0] || null;
};

/**
 * Actualiza el estado de una orden.
 * @param {number} id
 * @param {string} status  - 'pending' | 'paid' | 'shipped' | 'delivered' | 'cancelled'
 */
const updateStatus = async (id, status) => {
  const { rows } = await db.query(
    `UPDATE ecommerce.orden 
     SET id_estado = (SELECT id_estado FROM ecommerce.estado_orden WHERE nombre ILIKE $1 LIMIT 1)
     WHERE id_orden = $2 
     RETURNING id_orden AS id, total`,
    [status, id]
  );
  return rows[0] || null;
};

module.exports = { create, findByUser, findById, updateStatus };
