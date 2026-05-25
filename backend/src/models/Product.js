const db = require('../config/db');

/** Devuelve todos los productos disponibles con su primera categoría. */
const findAll = async () => {
  const { rows } = await db.query(
    `SELECT p.id_producto AS id, p.nombre AS name, p.descripcion AS description,
            p.precio AS price, p.stock, i.url AS image_url,
            c.nombre AS category
     FROM ecommerce.producto p
     LEFT JOIN (
       SELECT DISTINCT ON (id_producto) id_producto, url
       FROM ecommerce.imagen
     ) i ON i.id_producto = p.id_producto
     LEFT JOIN (
       SELECT DISTINCT ON (id_producto) id_producto, id_categoria
       FROM ecommerce.producto_categoria
     ) pc ON pc.id_producto = p.id_producto
     LEFT JOIN ecommerce.categoria c ON c.id_categoria = pc.id_categoria
     WHERE p.estado = 'DISPONIBLE'
     ORDER BY p.id_producto DESC`
  );
  return rows;
};

/**
 * Busca un producto por ID.
 * @param {number} id
 */
const findById = async (id) => {
  const { rows } = await db.query(
    `SELECT p.*, i.url AS image_url 
     FROM ecommerce.producto p
     LEFT JOIN ecommerce.imagen i ON i.id_producto = p.id_producto
     WHERE p.id_producto = $1 AND p.estado = 'DISPONIBLE'
     LIMIT 1`,
    [id]
  );
  if (rows.length === 0) return null;
  const p = rows[0];
  return {
    id: p.id_producto,
    name: p.nombre,
    description: p.descripcion,
    price: p.precio,
    stock: p.stock,
    image_url: p.image_url
  };
};

/**
 * Crea un nuevo producto.
 * @param {Object} data  - { name, description, price, stock, image_url, category_id, brand_id }
 */
const create = async ({ name, description, price, stock, image_url, brand_id = 1 }) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');
    
    // Insertar producto
    const prodRes = await client.query(
      `INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock, id_marca)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id_producto AS id, nombre, descripcion, precio, stock`,
      [name, description, price, stock, brand_id]
    );
    const product = prodRes.rows[0];

    // Insertar imagen si existe
    if (image_url) {
      await client.query(
        'INSERT INTO ecommerce.imagen (id_producto, url) VALUES ($1, $2)',
        [product.id, image_url]
      );
      product.image_url = image_url;
    }

    await client.query('COMMIT');
    return product;
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
};

/**
 * Actualiza un producto por ID.
 * @param {number} id
 * @param {Object} data
 */
const update = async (id, { name, description, price, stock, image_url }) => {
  const { rows } = await db.query(
    `UPDATE ecommerce.producto
     SET nombre=$1, descripcion=$2, precio=$3, stock=$4
     WHERE id_producto=$5
     RETURNING id_producto AS id, nombre, descripcion, precio, stock`,
    [name, description, price, stock, id]
  );
  if (rows.length === 0) return null;
  
  const product = rows[0];
  if (image_url) {
    await db.query(
      `INSERT INTO ecommerce.imagen (id_producto, url)
       VALUES ($1, $2)
       ON CONFLICT (id_producto) DO UPDATE SET url = EXCLUDED.url`,
      [id, image_url]
    );
    product.image_url = image_url;
  }
  
  return product;
};

const updateImage = async (id, image_url) => {
  await db.query(
    `UPDATE ecommerce.imagen SET url = $1 WHERE id_producto = $2`,
    [image_url, id]
  );
  return await findById(id);
};

/**
 * Desactiva (soft-delete) un producto.
 * @param {number} id
 */
const remove = async (id) => {
  await db.query("UPDATE ecommerce.producto SET estado = 'NO_DISPONIBLE' WHERE id_producto = $1", [id]);
};

module.exports = { findAll, findById, create, update, updateImage, remove };
