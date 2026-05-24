const router = require('express').Router();
const carritoController = require('../controllers/carrito.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken, checkRole('client'));

router.get('/',                  carritoController.getCarrito);
router.post('/add',            carritoController.addItem);
router.put('/update',          carritoController.updateItem);
router.delete('/remove/:itemId', carritoController.removeItem);

module.exports = router;