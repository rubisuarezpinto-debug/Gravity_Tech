const { sequelize } = require('../config/database');
const { QueryTypes } = require('sequelize');
const Orden = require('../models/orden.model');
const Usuario = require('../models/usuario.model');
const Producto = require('../models/producto.model');

const getSummary = async (req, res, next) => {
  try {
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);

    const [ventasHoy] = await sequelize.query(`
      SELECT COALESCE(SUM(total), 0) AS total, COUNT(*) AS pedidos
      FROM ecommerce.orden
      WHERE fecha_orden >= :hoy
    `, { replacements: { hoy }, type: QueryTypes.SELECT });

    const totalClientes = await Usuario.count({ where: { rol: 'cliente', estado: 'ACTIVO' } });
    const totalEmpleados = await Usuario.count({ where: { rol: ['trabajador', 'admin'] } });

    res.json({
      ventas_hoy: parseFloat(ventasHoy.total),
      pedidos_hoy: parseInt(ventasHoy.pedidos),
      total_clientes: totalClientes,
      total_empleados: totalEmpleados
    });
  } catch (error) {
    next(error);
  }
};

const getSalesChart = async (req, res, next) => {
  try {
    const { range = 'weekly' } = req.query;
    const dias = range === 'monthly' ? 30 : 7;

    const datos = await sequelize.query(`
      SELECT DATE(fecha_orden) AS fecha, COALESCE(SUM(total), 0) AS total, COUNT(*) AS pedidos
      FROM ecommerce.orden
      WHERE fecha_orden >= CURRENT_DATE - INTERVAL '${dias} days'
      GROUP BY DATE(fecha_orden)
      ORDER BY fecha ASC
    `, { type: QueryTypes.SELECT });

    res.json(datos);
  } catch (error) {
    next(error);
  }
};

const getTopProducts = async (req, res, next) => {
  try {
    const productos = await sequelize.query(`
      SELECT p.id_producto, p.nombre, SUM(oi.cantidad) AS total_vendido
      FROM ecommerce.orden_item oi
      JOIN ecommerce.producto p ON p.id_producto = oi.id_producto
      GROUP BY p.id_producto, p.nombre
      ORDER BY total_vendido DESC
      LIMIT 10
    `, { type: QueryTypes.SELECT });

    res.json(productos);
  } catch (error) {
    next(error);
  }
};

module.exports = { getSummary, getSalesChart, getTopProducts };