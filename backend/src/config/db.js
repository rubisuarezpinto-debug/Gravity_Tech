const { Pool } = require('pg');
require('dotenv').config();

// Creamos el pool de conexiones
const pool = new Pool({
  connectionString: process.env.DB_URL,
});

// Manejo de errores globales del pool
pool.on('error', (err) => {
  console.error('[ERROR] Error en el pool de PostgreSQL:', err);
});

/**
 * Ejecuta una query SQL contra la base de datos usando el pool.
 */
const query = (text, params) => pool.query(text, params);

module.exports = { 
  query, 
  pool 
};