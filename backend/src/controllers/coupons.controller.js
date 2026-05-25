const Coupon = require('../models/Coupon');

const validate = async (req, res, next) => {
  try {
    const { codigo } = req.body;
    const coupon = await Coupon.findByCode(codigo);
    if (!coupon) {
      return res.status(404).json({ success: false, error: 'Cupón inválido o expirado' });
    }
    res.json({ success: true, data: coupon });
  } catch (err) {
    next(err);
  }
};

const getAll = async (_req, res, next) => {
  try {
    const coupons = await Coupon.findAll();
    res.json({ success: true, data: coupons });
  } catch (err) {
    next(err);
  }
};

const create = async (req, res, next) => {
  try {
    const { codigo, discount_pct, activo, fecha_expiracion } = req.body;
    const coupon = await Coupon.create({ codigo, discount_pct, activo, fecha_expiracion });
    res.status(201).json({ success: true, data: coupon });
  } catch (err) {
    next(err);
  }
};

const toggle = async (req, res, next) => {
  try {
    const coupon = await Coupon.toggle(req.params.id);
    if (!coupon) return res.status(404).json({ success: false, error: 'Cupón no encontrado' });
    res.json({ success: true, data: coupon });
  } catch (err) {
    next(err);
  }
};

module.exports = { validate, getAll, create, toggle };
