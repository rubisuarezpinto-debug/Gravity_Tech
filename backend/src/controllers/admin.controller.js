const db = require('../config/db');
const Order = require('../models/Order');

/** GET /api/admin/users */
const getAllUsers = async (_req, res, next) => {
  try {
    const { rows } = await db.query(
      'SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC'
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
      `SELECT o.id, o.status, o.total, o.created_at,
              u.name AS user_name, u.email AS user_email
       FROM orders o
       JOIN users u ON u.id = o.user_id
       ORDER BY o.created_at DESC`
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
