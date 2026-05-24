const router = require('express').Router();
const analyticsController = require('../controllers/analytics.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken, checkRole('admin'));

router.get('/summary',      analyticsController.getSummary);

// CORREGIDO: Apunta a getSalesChart para que coincida con tu controlador.
// La ruta sigue siendo '/sales' intacta para la aplicación móvil.
router.get('/sales',        analyticsController.getSalesChart); 
router.get('/top-products', analyticsController.getTopProducts);

module.exports = router;