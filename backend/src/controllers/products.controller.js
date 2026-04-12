const Product = require('../models/Product');

/** GET /api/products */
const getAll = async (_req, res, next) => {
  try {
    const products = await Product.findAll();
    res.json({ products });
  } catch (err) {
    next(err);
  }
};

/** GET /api/products/:id */
const getOne = async (req, res, next) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Producto no encontrado' });
    res.json({ product });
  } catch (err) {
    next(err);
  }
};

/** POST /api/products  (admin) */
const create = async (req, res, next) => {
  try {
    const product = await Product.create(req.body);
    res.status(201).json({ product });
  } catch (err) {
    next(err);
  }
};

/** PUT /api/products/:id  (admin) */
const update = async (req, res, next) => {
  try {
    const product = await Product.update(req.params.id, req.body);
    if (!product) return res.status(404).json({ message: 'Producto no encontrado' });
    res.json({ product });
  } catch (err) {
    next(err);
  }
};

const updateImage = async (req, res, next) => {
  try {
    const { image_url } = req.body;
    if (!image_url) return res.status(400).json({ message: 'image_url requerida' });
    const product = await Product.updateImage(req.params.id, image_url);
    if (!product) return res.status(404).json({ message: 'Producto no encontrado' });
    res.json({ product });
  } catch (err) {
    next(err);
  }
};

/** DELETE /api/products/:id  (admin) */
const remove = async (req, res, next) => {
  try {
    await Product.remove(req.params.id);
    res.json({ message: 'Producto eliminado' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getAll, getOne, create, update, updateImage, remove };
