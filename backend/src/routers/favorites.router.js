const router = require('express').Router();
const { getMyFavorites, toggleFavorite } = require('../controllers/favorites.controller');
const authenticate = require('../middlewares/authenticate');
const { param } = require('express-validator');
const validateRequest = require('../validators/middleware');

const productIdSchema = [
  param('productId').isInt({ min: 1 }).withMessage('Product ID must be a positive integer').toInt(),
];

router.get('/',                                                      authenticate, getMyFavorites);
router.post('/:productId', productIdSchema, validateRequest, authenticate, toggleFavorite);

module.exports = router;
