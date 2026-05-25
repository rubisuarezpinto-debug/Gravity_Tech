const db = require('../config/db');

const findByCode = async (codigo) => {
  const { rows } = await db.query(
    `SELECT id_cupon AS id, codigo, porcentaje_descuento AS discount_pct,
            activo, fecha_expiracion
     FROM ecommerce.cupon
     WHERE codigo = $1
       AND activo = TRUE
       AND (fecha_expiracion IS NULL OR fecha_expiracion >= CURRENT_DATE)`,
    [codigo.toUpperCase()]
  );
  return rows[0] || null;
};

const findAll = async () => {
  const { rows } = await db.query(
    `SELECT id_cupon AS id, codigo, porcentaje_descuento AS discount_pct,
            activo, fecha_expiracion
     FROM ecommerce.cupon
     ORDER BY id_cupon DESC`
  );
  return rows;
};

const create = async ({ codigo, discount_pct, activo = true, fecha_expiracion = null }) => {
  const { rows } = await db.query(
    `INSERT INTO ecommerce.cupon (codigo, porcentaje_descuento, activo, fecha_expiracion)
     VALUES ($1, $2, $3, $4)
     RETURNING id_cupon AS id, codigo, porcentaje_descuento AS discount_pct, activo, fecha_expiracion`,
    [codigo.toUpperCase(), discount_pct, activo, fecha_expiracion]
  );
  return rows[0];
};

const toggle = async (id) => {
  const { rows } = await db.query(
    `UPDATE ecommerce.cupon
     SET activo = NOT activo
     WHERE id_cupon = $1
     RETURNING id_cupon AS id, codigo, activo`,
    [id]
  );
  return rows[0] || null;
};

module.exports = { findByCode, findAll, create, toggle };
