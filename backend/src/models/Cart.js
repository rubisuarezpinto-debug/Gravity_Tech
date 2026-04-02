const db = require('../config/db');

/**
 * Obtiene el carrito activo del usuario con sus items y product info.
 * @param {number} userId
 */
const findByUser = async (userId) => {
  const { rows } = await db.query(
    `SELECT ci.id, ci.quantity, p.id AS product_id, p.name, p.price, p.image_url,
            (ci.quantity * p.price) AS subtotal
     FROM cart_items ci
     JOIN products p ON p.id = ci.product_id
     WHERE ci.user_id = $1`,
    [userId]
  );
  return rows;
};

/**
 * Agrega o incrementa un item en el carrito.
 * @param {number} userId
 * @param {number} productId
 * @param {number} quantity
 */
const addItem = async (userId, productId, quantity = 1) => {
  const { rows } = await db.query(
    `INSERT INTO cart_items (user_id, product_id, quantity)
     VALUES ($1, $2, $3)
     ON CONFLICT (user_id, product_id)
     DO UPDATE SET quantity = cart_items.quantity + EXCLUDED.quantity
     RETURNING *`,
    [userId, productId, quantity]
  );
  return rows[0];
};

/**
 * Actualiza la cantidad de un item.
 * @param {number} itemId
 * @param {number} quantity
 */
const updateItem = async (itemId, quantity) => {
  const { rows } = await db.query(
    'UPDATE cart_items SET quantity = $1 WHERE id = $2 RETURNING *',
    [quantity, itemId]
  );
  return rows[0] || null;
};

/**
 * Elimina un item del carrito.
 * @param {number} itemId
 * @param {number} userId
 */
const removeItem = async (itemId, userId) => {
  await db.query('DELETE FROM cart_items WHERE id = $1 AND user_id = $2', [itemId, userId]);
};

/**
 * Vacía todo el carrito de un usuario.
 * @param {number} userId
 */
const clearCart = async (userId) => {
  await db.query('DELETE FROM cart_items WHERE user_id = $1', [userId]);
};

module.exports = { findByUser, addItem, updateItem, removeItem, clearCart };
