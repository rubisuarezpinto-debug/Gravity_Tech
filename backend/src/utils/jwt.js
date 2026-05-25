const jwt = require('jsonwebtoken');

if (!process.env.JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable is required');
}
const SECRET = process.env.JWT_SECRET;
const EXPIRES_IN = process.env.JWT_EXPIRES_IN || '1d';

/**
 * Genera un JWT firmado con el payload dado.
 * @param {Object} payload
 * @returns {string} token
 */
const sign = (payload) => jwt.sign(payload, SECRET, { expiresIn: EXPIRES_IN });

/**
 * Verifica y decodifica un JWT.
 * @param {string} token
 * @returns {Object} decoded payload
 */
const verify = (token) => jwt.verify(token, SECRET);

module.exports = { sign, verify };
