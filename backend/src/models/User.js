const db = require('../config/db');
const { hash, compare } = require('../utils/hash');

/**
 * Crea un nuevo usuario.
 * @param {string} nombre
 * @param {string} email
 * @param {string} plainPassword
 * @param {string} rol  - 'cliente' | 'admin'
 */
const create = async (nombre, email, plainPassword, rol = 'cliente') => {
  const passwordHash = await hash(plainPassword);
  const { rows } = await db.query(
    `INSERT INTO ecommerce.usuario (nombre, email, password_hash, rol)
     VALUES ($1, $2, $3, $4)
     RETURNING id_usuario AS id, nombre, email, rol`,
    [nombre, email, passwordHash, rol]
  );
  return rows[0];
};

/**
 * Busca un usuario por email.
 * @param {string} email
 */
const findByEmail = async (email) => {
  const { rows } = await db.query(
    'SELECT id_usuario AS id, nombre, email, password_hash, rol FROM ecommerce.usuario WHERE email = $1',
    [email]
  );
  return rows[0] || null;
};

/**
 * Busca un usuario por ID.
 * @param {number} id
 */
const findById = async (id) => {
  const { rows } = await db.query(
    'SELECT id_usuario AS id, nombre, email, rol FROM ecommerce.usuario WHERE id_usuario = $1',
    [id]
  );
  return rows[0] || null;
};

/**
 * Verifica si la contraseña coincide con el hash almacenado.
 * @param {string} plainPassword
 * @param {string} hashedPassword
 */
const verifyPassword = (plainPassword, hashedPassword) =>
  compare(plainPassword, hashedPassword);

module.exports = { create, findByEmail, findById, verifyPassword };
