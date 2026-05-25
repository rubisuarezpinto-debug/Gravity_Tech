const router = require('express').Router();
const { getAllUsers, getAllOrders, updateOrderStatus } = require('../controllers/admin.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// Todas requieren estar autenticado y tener rol 'admin'
router.use(authenticate, authorize('admin'));

router.get('/users', getAllUsers);
router.get('/orders', getAllOrders);
router.patch('/orders/:id/status', updateOrderStatus);

module.exports = router;
