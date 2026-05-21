const Order = require('../models/Order');
const Cart = require('../models/Cart');
const Payment = require('../models/Payment');

const getMyOrders = async (req, res, next) => {
  try {
    const orders = await Order.findByUser(req.user.id);
    res.json(orders);
  } catch (err) {
    next(err);
  }
};

const getOne = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'Orden no encontrada' });

    const userRole = req.user.role || req.user.rol;

    if (order.user_id !== req.user.id && userRole !== 'admin') {
      return res.status(403).json({ message: 'Acceso denegado' });
    }
    res.json(order);
  } catch (err) {
    next(err);
  }
};

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
    await Order.updateStatus(order.id, 'Pago Confirmado');

    res.status(201).json({ message: 'Orden creada con éxito', order });
  } catch (err) {
    next(err);
  }
};

module.exports = { getMyOrders, getOne, checkout };