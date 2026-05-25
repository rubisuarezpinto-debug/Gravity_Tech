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
    `SELECT id_usuario AS id, nombre, email, password_hash, rol, estado, telefono
     FROM ecommerce.usuario
     WHERE email = $1`,
    [email]
  );
  return rows[0] || null;
};

const findById = async (id) => {
  const { rows } = await db.query(
    `SELECT id_usuario AS id, nombre, email, rol, estado, telefono
     FROM ecommerce.usuario
     WHERE id_usuario = $1`,
    [id]
  );
  return rows[0] || null;
};

const verifyPassword = (plainPassword, hashedPassword) =>
  compare(plainPassword, hashedPassword);

const updatePassword = async (id, newPasswordHash) => {
  await db.query(
    `UPDATE ecommerce.usuario
     SET password_hash = $1, fecha_actualizacion = CURRENT_TIMESTAMP
     WHERE id_usuario = $2`,
    [newPasswordHash, id]
  );
};

const getPasswordHash = async (id) => {
  const { rows } = await db.query(
    'SELECT password_hash FROM ecommerce.usuario WHERE id_usuario = $1',
    [id]
  );
  return rows[0]?.password_hash ?? null;
};

const saveSmsCode = async (id, code, expiresAt) => {
  await db.query(
    `UPDATE ecommerce.usuario
     SET sms_code = $1, sms_expires_at = $2
     WHERE id_usuario = $3`,
    [code, expiresAt, id]
  );
};

const verifySmsCode = async (id, code) => {
  const { rows } = await db.query(
    `SELECT sms_code, sms_expires_at
     FROM ecommerce.usuario
     WHERE id_usuario = $1`,
    [id]
  );
  if (!rows[0]) return false;
  const { sms_code, sms_expires_at } = rows[0];
  return sms_code === code && new Date(sms_expires_at) > new Date();
};

const clearSmsCode = async (id) => {
  await db.query(
    `UPDATE ecommerce.usuario
     SET sms_code = NULL, sms_expires_at = NULL
     WHERE id_usuario = $1`,
    [id]
  );
};

module.exports = {
  create,
  findByEmail,
  findById,
  verifyPassword,
  updatePassword,
  getPasswordHash,
  saveSmsCode,
  verifySmsCode,
  clearSmsCode,
};
