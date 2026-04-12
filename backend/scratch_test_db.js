const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DB_URL,
});

async function test() {
  try {
    console.log('Testing connection to:', process.env.DB_URL);
    const res = await pool.query('SELECT current_schema(), current_database()');
    console.log('Result:', res.rows[0]);
    
    const prodRes = await pool.query('SELECT * FROM ecommerce.producto LIMIT 1');
    console.log('Product query success. Count:', prodRes.rows.length);
  } catch (err) {
    console.error('Error during test:', err);
  } finally {
    await pool.end();
  }
}

test();
