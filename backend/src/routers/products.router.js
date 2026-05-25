const router = require('express').Router();
const { getAll, getOne, create, update, updateImage, remove } = require('../controllers/products.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// Públicas
router.get('/', getAll);
router.get('/:id', getOne);

// Protegidas — admin y trabajador
router.post('/', authenticate, authorize('admin', 'trabajador'), create);
router.put('/:id', authenticate, authorize('admin', 'trabajador'), update);
router.put('/:id/image', authenticate, authorize('admin', 'trabajador'), updateImage);
router.delete('/:id', authenticate, authorize('admin', 'trabajador'), remove);

module.exports = router;
