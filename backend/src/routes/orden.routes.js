const router = require('express').Router();
const ordenController = require('../controllers/orden.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken);

// Las URLs se quedan EXACTAMENTE igual para tu app móvil, solo cambiamos la función que ejecutan:
router.post('/checkout',    checkRole('client'), ordenController.checkout);
router.get('/my-orders',    checkRole('client'), ordenController.getMisOrdenes);  // ◄─ Corregido
router.put('/:id/status',   checkRole('worker', 'admin'), ordenController.updateEstado); // ◄─ Corregido

module.exports = router;