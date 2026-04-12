const router = require('express').Router();
const { getAll, getOne, create, update, updateImage, remove } = require('../controllers/products.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// Públicas
router.get('/', getAll);
router.get('/:id', getOne);

// Protegidas — solo admin
router.post('/', authenticate, authorize('admin'), create);
router.put('/:id', authenticate, authorize('admin'), update);
router.put('/:id/image', authenticate, authorize('admin'), updateImage);
router.delete('/:id', authenticate, authorize('admin'), remove);

module.exports = router;
