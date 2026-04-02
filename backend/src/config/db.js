const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DB_URL,
});

pool.on('connect', () => {
  console.log('✅ Conectado a PostgreSQL');
});

pool.on('error', (err) => {
  console.error('❌ Error en pool de PostgreSQL:', err);
  process.exit(-1);
});

/**
 * Ejecuta una query SQL contra la base de datos.
 * @param {string} text  - Sentencia SQL con placeholders ($1, $2, ...)
 * @param {Array}  params - Parámetros para la sentencia
 */
const query = (text, params) => pool.query(text, params);

module.exports = { query, pool };
