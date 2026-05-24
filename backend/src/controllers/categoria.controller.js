const Categoria = require('../models/categoria.model');

// ─── Obtener todas las categorías ─────────────────────────────────────────────
const getAll = async (req, res, next) => {
  try {
    const categories = await Categoria.findAll();
    res.json({ categories });
  } catch (error) {
    next(error);
  }
};

// ─── Obtener categoría por ID ─────────────────────────────────────────────────
const getById = async (req, res, next) => {
  try {
    const categoria = await Categoria.findByPk(req.params.id);
    if (!categoria) return res.status(404).json({ message: 'Categoría no encontrada' });
    res.json({ category: categoria });
  } catch (error) {
    next(error);
  }
};

// ─── Crear categoría ──────────────────────────────────────────────────────────
const create = async (req, res, next) => {
  try {
    const { nombre } = req.body;
    const categoria = await Categoria.create({ nombre });
    res.status(201).json({ message: 'Categoría creada', categoria });
  } catch (error) {
    next(error);
  }
};

// ─── Actualizar categoría ─────────────────────────────────────────────────────
const update = async (req, res, next) => {
  try {
    const categoria = await Categoria.findByPk(req.params.id);
    if (!categoria) return res.status(404).json({ message: 'Categoría no encontrada' });

    await categoria.update({ nombre: req.body.nombre });
    res.json({ message: 'Categoría actualizada', categoria });
  } catch (error) {
    next(error);
  }
};

// ─── Eliminar categoría ───────────────────────────────────────────────────────
const remove = async (req, res, next) => {
  try {
    const categoria = await Categoria.findByPk(req.params.id);
    if (!categoria) return res.status(404).json({ message: 'Categoría no encontrada' });

    await categoria.destroy();
    res.json({ message: 'Categoría eliminada' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAll,
  getById,
  create,
  update,
  remove
};