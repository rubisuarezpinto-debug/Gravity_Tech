const Order = require('../models/Order');
const Cart = require('../models/Cart');
const Payment = require('../models/Payment');

/** GET /api/orders */
const getMyOrders = async (req, res, next) => {
  try {
    const orders = await Order.findByUser(req.user.id);
    res.json({ orders });
  } catch (err) {
    next(err);
  }
};

/** GET /api/orders/:id */
const getOne = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'Orden no encontrada' });
    if (order.user_id !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Acceso denegado' });
    }
    res.json({ order });
  } catch (err) {
    next(err);
  }
};

/** POST /api/orders/checkout */
const checkout = async (req, res, next) => {
  try {
    const { payment_method } = req.body;
    const items = await Cart.findByUser(req.user.id);

    if (!items.length) {
      return res.status(400).json({ message: 'El carrito está vacío' });
    }

    const orderItems = items.map((i) => ({
      product_id: i.product_id,
      quantity: i.quantity,
      unit_price: i.price,
    }));
    const total = items.reduce((acc, i) => acc + Number(i.subtotal), 0);

    const order = await Order.create(req.user.id, orderItems, total);
    await Payment.create(order.id, total, payment_method || 'card');
    await Cart.clearCart(req.user.id);
    await Order.updateStatus(order.id, 'paid');

    res.status(201).json({ message: 'Orden creada con éxito', order });
  } catch (err) {
    next(err);
  }
};

module.exports = { getMyOrders, getOne, checkout };
