const db = require('../config/db');

/**
 * Devuelve todas las reseñas de un producto, incluyendo el email del usuario.
 * @param {number} productId
 */
const findByProduct = async (productId) => {
  const { rows } = await db.query(
    `SELECT r.id_resena, r.comentario, r.puntuacion,
            u.email AS usuario_email
     FROM ecommerce.resena r
     JOIN ecommerce.usuario u ON u.id_usuario = r.id_usuario
     WHERE r.id_producto = $1
     ORDER BY r.id_resena DESC`,
    [productId]
  );
  return rows;
};

/**
 * Crea una nueva reseña.
 * @param {number} userId
 * @param {number} productId
 * @param {string} comentario
 * @param {number} puntuacion  - entre 1 y 5
 */
const create = async (userId, productId, comentario, puntuacion) => {
  const { rows } = await db.query(
    `INSERT INTO ecommerce.resena (id_usuario, id_producto, comentario, puntuacion)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [userId, productId, comentario, puntuacion]
  );
  return rows[0];
};

/**
 * Elimina una reseña solo si pertenece al usuario indicado.
 * @param {number} reviewId
 * @param {number} userId
 */
const remove = async (reviewId, userId) => {
  const { rowCount } = await db.query(
    `DELETE FROM ecommerce.resena
     WHERE id_resena = $1 AND id_usuario = $2`,
    [reviewId, userId]
  );
  return rowCount > 0;
};

/**
 * Devuelve el promedio de puntuación de un producto.
 * @param {number} productId
 */
const avgByProduct = async (productId) => {
  const { rows } = await db.query(
    `SELECT ROUND(AVG(puntuacion)::numeric, 1) AS promedio,
            COUNT(*) AS total
     FROM ecommerce.resena
     WHERE id_producto = $1`,
    [productId]
  );
  return rows[0];
};

module.exports = { findByProduct, create, remove, avgByProduct };
