const router = require('express').Router();
const { getAll, getOne, create, update, updateImage, remove } = require('../controllers/products.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// Públicas
router.get('/', getAll);
router.get('/:id', getOne);

// Protegidas — admin y empleado
router.post('/', authenticate, authorize('admin', 'empleado'), create);
router.put('/:id', authenticate, authorize('admin', 'empleado'), update);
router.put('/:id/image', authenticate, authorize('admin', 'empleado'), updateImage);
router.delete('/:id', authenticate, authorize('admin', 'empleado'), remove);

module.exports = router;
