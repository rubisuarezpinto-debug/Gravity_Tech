const router = require('express').Router();
const { getMyOrders, getOne, checkout } = require('../controllers/orders.controller');
const authenticate = require('../middlewares/authenticate');

router.use(authenticate);

router.get('/', getMyOrders);
router.get('/:id', getOne);
router.post('/checkout', checkout);

module.exports = router;
