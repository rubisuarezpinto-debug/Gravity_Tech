  const pool = require('../config/db');

  // ==========================================
  // ── MÓDULO CLIENTE ──
  // ==========================================

  const obtenerCategorias = async (req, res, next) => {
    try {
      const result = await pool.query('SELECT id_categoria, nombre FROM ecommerce.categoria ORDER BY nombre ASC');
      res.status(200).json({ b_exito: true, o_datos: result.rows });
    } catch (err) { next(err); }
  };
// En tu controlador, actualiza la consulta SQL:
const listarCatalogo = async (req, res, next) => {
  try {
    // Usamos LEFT JOIN para obtener la imagen principal sin modificar la estructura original
    const result = await pool.query(`
      SELECT p.id_producto AS id, 
             p.nombre, 
             p.descripcion, 
             p.precio, 
             p.stock, 
             i.url AS "imageUrl", -- Esto toma la URL de la tabla imagen
             c.id_categoria, 
             c.nombre AS categoryName
      FROM ecommerce.producto p
      LEFT JOIN ecommerce.imagen i ON p.id_producto = i.id_producto AND i.es_principal = TRUE
      LEFT JOIN ecommerce.producto_categoria pc ON p.id_producto = pc.id_producto
      LEFT JOIN ecommerce.categoria c ON pc.id_categoria = c.id_categoria
      ORDER BY p.nombre ASC
    `);
    
    res.status(200).json(result.rows); 
  } catch (err) { next(err); }
};
  // ==========================================
  // ── MÓDULO EMPLEADO (CRUD Inventario) ──
  // ==========================================

  const registrarProducto = async (req, res, next) => {
    try {
      const { nombre, descripcion, precio, stock, idCategoria } = req.body;
      const result = await pool.query(
        `INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock) VALUES ($1, $2, $3, $4) RETURNING *`,
        [nombre, descripcion, precio, stock]
      );
      res.status(201).json(result.rows[0]);
    } catch (err) { next(err); }
  };

  const actualizarProducto = async (req, res, next) => {
    try {
      const { id } = req.params;
      const { nombre, descripcion, precio, stock } = req.body;
      const result = await pool.query(
        `UPDATE ecommerce.producto SET nombre=$1, descripcion=$2, precio=$3, stock=$4 WHERE id_producto=$5 RETURNING *`,
        [nombre, descripcion, precio, stock, id]
      );
      res.status(200).json(result.rows[0]);
    } catch (err) { next(err); }
  };

  const eliminarProducto = async (req, res, next) => {
    try {
      const { id } = req.params;
      await pool.query('DELETE FROM ecommerce.producto WHERE id_producto = $1', [id]);
      res.status(200).json({ b_exito: true, v_mensaje: 'Producto eliminado.' });
    } catch (err) { next(err); }
  };

  module.exports = {
    obtenerCategorias,
    listarCatalogo,
    registrarProducto,
    actualizarProducto,
    eliminarProducto
  };