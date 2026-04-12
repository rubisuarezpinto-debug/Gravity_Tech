const db = require('../config/db');

/** Devuelve todos los productos activos. */
const findAll = async () => {
  const { rows } = await db.query(
    `SELECT id, name, description, price, stock, image_url, category_id
     FROM products
     WHERE active = TRUE
     ORDER BY created_at DESC`
  );
  return rows;
};

/**
 * Busca un producto por ID.
 * @param {number} id
 */
const findById = async (id) => {
  const { rows } = await db.query(
    'SELECT * FROM products WHERE id = $1 AND active = TRUE',
    [id]
  );
  return rows[0] || null;
};

/**
 * Crea un nuevo producto.
 * @param {Object} data  - { name, description, price, stock, image_url, category_id }
 */
const create = async ({ name, description, price, stock, category_id, brand_id }) => {
  await db.query(
    `INSERT INTO products (name, description, price, stock, category_id, brand_id)
     VALUES ($1, $2, $3, $4, $5, $6)`,
    [name, description, price, stock, category_id, brand_id]
  );
  const { rows } = await db.query(
    `SELECT * FROM products WHERE name = $1 ORDER BY id DESC LIMIT 1`,
    [name]
  );
  return rows[0];
};

/**
 * Actualiza un producto por ID.
 * @param {number} id
 * @param {Object} data
 */
const update = async (id, { name, description, price, stock, brand_id, category_id }) => {
  await db.query(
    `UPDATE products
     SET name=$1, description=$2, price=$3, stock=$4, brand_id=$5, category_id=$6
     WHERE id=$7`,
    [name, description, price, stock, brand_id, category_id, id]
  );
  return await findById(id);
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
  await db.query('DELETE FROM products WHERE id = $1', [id]);
};

module.exports = { findAll, findById, create, update, updateImage, remove };
