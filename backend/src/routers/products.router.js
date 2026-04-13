const router = require('express').Router();
const { getAll, getOne, create, update, updateImage, remove } = require('../controllers/products.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// Públicas
router.get('/', getAll);
router.get('/:id', getOne);

// Protegidas — solo admin
router.post('/', authenticate, authorize('administrador'), create);
router.put('/:id', authenticate, authorize('administrador'), update);
router.put('/:id/image', authenticate, authorize('administrador'), updateImage);
router.delete('/:id', authenticate, authorize('administrador'), remove);

module.exports = router;
