const db = require('../config/db');

const findByUser = async (userId) => {
  const { rows } = await db.query(
    `SELECT f.id_favorito AS id, f.fecha_agregado,
            p.id_producto AS product_id, p.nombre AS name,
            p.precio AS price, i.url AS image_url
     FROM ecommerce.favorito f
     JOIN ecommerce.producto p ON p.id_producto = f.id_producto
     LEFT JOIN ecommerce.imagen i
       ON i.id_producto = p.id_producto AND i.es_principal = TRUE
     WHERE f.id_usuario = $1
     ORDER BY f.fecha_agregado DESC`,
    [userId]
  );
  return rows;
};

const toggle = async (userId, productId) => {
  const { rows } = await db.query(
    'SELECT id_favorito FROM ecommerce.favorito WHERE id_usuario = $1 AND id_producto = $2',
    [userId, productId]
  );

  if (rows.length > 0) {
    await db.query(
      'DELETE FROM ecommerce.favorito WHERE id_usuario = $1 AND id_producto = $2',
      [userId, productId]
    );
    return { action: 'removed' };
  }

  const { rows: inserted } = await db.query(
    `INSERT INTO ecommerce.favorito (id_usuario, id_producto)
     VALUES ($1, $2)
     RETURNING id_favorito AS id, fecha_agregado`,
    [userId, productId]
  );
  return { action: 'added', favorite: inserted[0] };
};

module.exports = { findByUser, toggle };
