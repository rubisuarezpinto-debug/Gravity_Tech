const db = require('../config/db');

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

const create = async (userId, productId, comentario, puntuacion) => {
  const { rows } = await db.query(
    `INSERT INTO ecommerce.resena (id_usuario, id_producto, comentario, puntuacion)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [userId, productId, comentario, puntuacion]
  );
  return rows[0];
};

const remove = async (reviewId, userId) => {
  const { rowCount } = await db.query(
    `DELETE FROM ecommerce.resena
     WHERE id_resena = $1 AND id_usuario = $2`,
    [reviewId, userId]
  );
  return rowCount > 0;
};

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