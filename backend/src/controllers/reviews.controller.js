const Review = require('../models/Review');

const getByProduct = async (req, res, next) => {
  try {
    const { productId } = req.params;
    const [reviews, stats] = await Promise.all([
      Review.findByProduct(productId),
      Review.avgByProduct(productId),
    ]);
    res.json({
      reviews,
      promedio: stats?.promedio || 0,
      total: stats?.total || 0
    });
  } catch (err) {
    next(err);
  }
};

const create = async (req, res, next) => {
  try {
    const { productId } = req.params;
    const { comentario, puntuacion } = req.body;

    if (!puntuacion || puntuacion < 1 || puntuacion > 5) {
      return res.status(400).json({ message: 'La puntuación debe estar entre 1 y 5' });
    }

    const review = await Review.create(
      req.user.id,
      productId,
      comentario || null,
      puntuacion
    );
    res.status(201).json(review);
  } catch (err) {
    next(err);
  }
};

const remove = async (req, res, next) => {
  try {
    const deleted = await Review.remove(req.params.id, req.user.id);
    if (!deleted) {
      return res.status(404).json({ message: 'Reseña no encontrada o no autorizada' });
    }
    res.json({ message: 'Reseña eliminada' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getByProduct, create, remove };