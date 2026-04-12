const db = require('../config/db');
const Order = require('../models/Order');

/** GET /api/admin/users */
const getAllUsers = async (_req, res, next) => {
  try {
    const { rows } = await db.query(
      'SELECT id_usuario AS id, nombre AS name, email, rol AS role FROM ecommerce.usuario ORDER BY id_usuario DESC'
    );
    res.json({ users: rows });
  } catch (err) {
    next(err);
  }
};

/** GET /api/admin/orders */
const getAllOrders = async (_req, res, next) => {
  try {
    const { rows } = await db.query(
      `SELECT o.id_orden AS id, s.nombre AS status, o.total, o.fecha_orden AS created_at,
              u.nombre AS user_name, u.email AS user_email,
              COALESCE(
                json_agg(
                  json_build_object(
                    'name',       p.nombre,
                    'quantity',   oi.cantidad,
                    'unit_price', oi.precio_unitario
                  )
                ) FILTER (WHERE oi.id_orden_item IS NOT NULL),
                '[]'
              ) AS items
       FROM ecommerce.orden o
       JOIN ecommerce.usuario u     ON u.id_usuario = o.id_usuario
       JOIN ecommerce.estado_orden s ON s.id_estado = o.id_estado
       LEFT JOIN ecommerce.orden_item oi ON oi.id_orden = o.id_orden
       LEFT JOIN ecommerce.producto p   ON p.id_producto = oi.id_producto
       GROUP BY o.id_orden, s.nombre, u.nombre, u.email
       ORDER BY o.fecha_orden DESC`
    );
    res.json({ orders: rows });
  } catch (err) {
    next(err);
  }
};

/** PATCH /api/admin/orders/:id/status */
const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const order = await Order.updateStatus(req.params.id, status);
    if (!order) return res.status(404).json({ message: 'Orden no encontrada' });
    res.json({ order });
  } catch (err) {
    next(err);
  }
};

module.exports = { getAllUsers, getAllOrders, updateOrderStatus };
