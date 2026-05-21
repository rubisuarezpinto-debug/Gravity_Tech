const db = require('../config/db');

const findByUser = async (userId) => {
  const { rows } = await db.query(
    `SELECT ci.id_carrito_item AS id, ci.cantidad AS quantity, 
            p.id_producto AS product_id, p.nombre AS name, p.precio AS price, i.url AS image_url,
            (ci.cantidad * ci.precio_unitario) AS subtotal
     FROM ecommerce.carrito_item ci
     JOIN ecommerce.carrito c ON c.id_carrito = ci.id_carrito
     JOIN ecommerce.producto p ON p.id_producto = ci.id_producto
     LEFT JOIN (
       SELECT DISTINCT ON (id_producto) id_producto, url 
       FROM ecommerce.imagen
     ) i ON i.id_producto = p.id_producto
     WHERE c.id_usuario = $1 AND c.estado = 'ABIERTO'`,
    [userId]
  );
  return rows;
};

const addItem = async (userId, productId, quantity = 1) => {
  const client = await (db.pool ? db.pool.connect() : db.connect());
  try {
    await client.query('BEGIN');

    let cartRes = await client.query(
      "SELECT id_carrito FROM ecommerce.carrito WHERE id_usuario = $1 AND estado = 'ABIERTO'",
      [userId]
    );
    let cartId;
    if (cartRes.rows.length === 0) {
      cartRes = await client.query(
        "INSERT INTO ecommerce.carrito (id_usuario) VALUES ($1) RETURNING id_carrito",
        [userId]
      );
    }
    cartId = cartRes.rows[0].id_carrito;

    const prodRes = await client.query('SELECT precio FROM ecommerce.producto WHERE id_producto = $1', [productId]);
    const price = prodRes.rows[0].precio;

    const itemRes = await client.query(
      `INSERT INTO ecommerce.carrito_item (id_carrito, id_producto, cantidad, precio_unitario)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (id_carrito, id_producto) 
       DO UPDATE SET cantidad = ecommerce.carrito_item.cantidad + EXCLUDED.cantidad
       RETURNING *`,
      [cartId, productId, quantity, price]
    );

    await client.query('COMMIT');
    return itemRes.rows[0];
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
};

const updateItem = async (itemId, quantity) => {
  const { rows } = await db.query(
    'UPDATE ecommerce.carrito_item SET cantidad = $1 WHERE id_carrito_item = $2 RETURNING *',
    [quantity, itemId]
  );
  return rows[0] || null;
};

const removeItem = async (itemId, userId) => {
  await db.query(
    `DELETE FROM ecommerce.carrito_item 
     WHERE id_carrito_item = $1 
     AND id_carrito IN (SELECT id_carrito FROM ecommerce.carrito WHERE id_usuario = $2)`,
    [itemId, userId]
  );
};

const clearCart = async (userId) => {
  await db.query(
    "DELETE FROM ecommerce.carrito_item WHERE id_carrito IN (SELECT id_carrito FROM ecommerce.carrito WHERE id_usuario = $1 AND estado = 'ABIERTO')",
    [userId]
  );
};

module.exports = { findByUser, addItem, updateItem, removeItem, clearCart };