const db = require('../config/db');
const { hash, compare } = require('../utils/hash');

/**
 * Crea un nuevo usuario.
 * @param {string} name
 * @param {string} email
 * @param {string} plainPassword
 * @param {string} role  - 'cliente' | 'admin'
 */
const create = async (name, email, plainPassword, role = 'cliente') => {
  const passwordHash = await hash(plainPassword);
  await db.query(
    `INSERT INTO users (name, email, password_hash)
     VALUES ($1, $2, $3)`,
    [name, email, passwordHash]
  );
  return await findByEmail(email);
};

/**
 * Busca un usuario por email.
 * @param {string} email
 */
const findByEmail = async (email) => {
  const { rows } = await db.query(
    'SELECT * FROM users WHERE email = $1',
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
    'SELECT id, name, email, role, created_at FROM users WHERE id = $1',
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
