const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET || 'changeme_in_env';
const EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

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
