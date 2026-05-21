const db = require('../config/db');
const { hash, compare } = require('../utils/hash');

const create = async (nombre, email, plainPassword, rol = 'cliente', telefono = null) => {
  const passwordHash = await hash(plainPassword);
  const { rows } = await db.query(
    `INSERT INTO ecommerce.usuario (nombre, email, password_hash, rol, telefono)
     VALUES ($1, $2, $3, $4, $5)
     RETURNING id_usuario AS id, nombre, email, rol, telefono`,
    [nombre, email, passwordHash, rol, telefono]
  );
  return rows[0];
};

const findByEmail = async (email) => {
  const { rows } = await db.query(
    `SELECT id_usuario AS id, nombre, email, password_hash, rol, telefono 
     FROM ecommerce.usuario 
     WHERE email = $1`,
    [email]
  );
  return rows[0] || null;
};

const findById = async (id) => {
  const { rows } = await db.query(
    `SELECT id_usuario AS id, nombre, email, rol, telefono 
     FROM ecommerce.usuario 
     WHERE id_usuario = $1`,
    [id]
  );
  return rows[0] || null;
};

const verifyPassword = async (plainPassword, hashedPassword) => {
  return await compare(plainPassword, hashedPassword);
};

module.exports = { create, findByEmail, findById, verifyPassword };