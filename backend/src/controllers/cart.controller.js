const Cart = require('../models/Cart');

/** GET /api/cart */
const getCart = async (req, res, next) => {
  try {
    const items = await Cart.findByUser(req.user.id);
    res.json({ items });
  } catch (err) {
    next(err);
  }
};

/** POST /api/cart */
const addItem = async (req, res, next) => {
  try {
    const { product_id, quantity } = req.body;
    if (!product_id) return res.status(400).json({ message: 'product_id requerido' });
    const item = await Cart.addItem(req.user.id, product_id, quantity);
    res.status(201).json({ item });
  } catch (err) {
    next(err);
  }
};

/** PUT /api/cart/:itemId */
const updateItem = async (req, res, next) => {
  try {
    const { quantity } = req.body;
    if (!quantity || quantity < 1) {
      return res.status(400).json({ message: 'Cantidad inválida' });
    }
    const item = await Cart.updateItem(req.params.itemId, quantity);
    if (!item) return res.status(404).json({ message: 'Item no encontrado' });
    res.json({ item });
  } catch (err) {
    next(err);
  }
};

/** DELETE /api/cart/:itemId */
const removeItem = async (req, res, next) => {
  try {
    await Cart.removeItem(req.params.itemId, req.user.id);
    res.json({ message: 'Item eliminado del carrito' });
  } catch (err) {
    next(err);
  }
};

/** DELETE /api/cart */
const clearCart = async (req, res, next) => {
  try {
    await Cart.clearCart(req.user.id);
    res.json({ message: 'Carrito vaciado' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getCart, addItem, updateItem, removeItem, clearCart };
