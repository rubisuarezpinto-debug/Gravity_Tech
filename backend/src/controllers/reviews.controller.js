const Review = require('../models/Review');

/**
 * GET /api/reviews/product/:productId
 * Devuelve todas las reseñas de un producto + promedio de puntuación.
 * Ruta pública.
 */
const getByProduct = async (req, res, next) => {
  try {
    const { productId } = req.params;
    const [reviews, stats] = await Promise.all([
      Review.findByProduct(productId),
      Review.avgByProduct(productId),
    ]);
    res.json({ reviews, stats });
  } catch (err) {
    next(err);
  }
};

/**
 * POST /api/reviews/product/:productId
 * Crea una reseña para el producto autenticado.
 * Requiere JWT.
 */
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
    res.status(201).json({ review });
  } catch (err) {
    next(err);
  }
};

/**
 * DELETE /api/reviews/:id
 * Elimina la reseña solo si pertenece al usuario autenticado.
 * Requiere JWT.
 */
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
