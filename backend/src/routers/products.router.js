const router = require('express').Router();
const { getAll, getOne, create, update, remove } = require('../controllers/products.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// Públicas
router.get('/', getAll);
router.get('/:id', getOne);

// Protegidas — solo admin
router.post('/', authenticate, authorize('admin'), create);
router.put('/:id', authenticate, authorize('admin'), update);
router.delete('/:id', authenticate, authorize('admin'), remove);

module.exports = router;
