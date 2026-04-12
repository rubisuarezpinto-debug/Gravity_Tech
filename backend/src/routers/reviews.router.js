const router = require('express').Router();
const { getByProduct, create, remove } = require('../controllers/reviews.controller');
const authenticate = require('../middlewares/authenticate');

// Pública: listar reseñas + estadísticas de un producto
router.get('/product/:productId', getByProduct);

// Protegidas: requieren sesión
router.post('/product/:productId', authenticate, create);
router.delete('/:id', authenticate, remove);

module.exports = router;
