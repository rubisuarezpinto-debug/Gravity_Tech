const bcrypt = require('bcryptjs');

const SALT_ROUNDS = 12;

/**
 * Hashea una contraseña en texto plano.
 * @param {string} plainPassword
 * @returns {Promise<string>} hash
 */
const hash = (plainPassword) => bcrypt.hash(plainPassword, SALT_ROUNDS);

/**
 * Compara una contraseña en texto plano con su hash.
 * @param {string} plainPassword
 * @param {string} hashedPassword
 * @returns {Promise<boolean>}
 */
const compare = (plainPassword, hashedPassword) =>
  bcrypt.compare(plainPassword, hashedPassword);

module.exports = { hash, compare };
