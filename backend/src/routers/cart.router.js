const router = require('express').Router();
const { getCart, addItem, updateItem, removeItem, clearCart } = require('../controllers/cart.controller');
const authenticate = require('../middlewares/authenticate');

router.use(authenticate);

router.get('/', getCart);
router.post('/', addItem);
router.put('/:itemId', updateItem);
router.delete('/:itemId', removeItem);
router.delete('/', clearCart);

module.exports = router;