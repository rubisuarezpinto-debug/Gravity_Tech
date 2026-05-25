const Favorite = require('../models/Favorite');

const getMyFavorites = async (req, res, next) => {
  try {
    const favorites = await Favorite.findByUser(req.user.id);
    res.json({ success: true, data: favorites });
  } catch (err) {
    next(err);
  }
};

const toggleFavorite = async (req, res, next) => {
  try {
    const productId = parseInt(req.params.productId, 10);
    const result = await Favorite.toggle(req.user.id, productId);
    res.json({ success: true, data: result });
  } catch (err) {
    next(err);
  }
};

module.exports = { getMyFavorites, toggleFavorite };
