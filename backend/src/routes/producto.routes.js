const router = require('express').Router();
const productoController = require('../controllers/producto.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

// Rutas públicas (cliente autenticado)
router.get('/',           verifyToken, productoController.getAll);
router.get('/low-stock',  verifyToken, checkRole('worker', 'admin'), productoController.getLowStock);
router.get('/:id',        verifyToken, productoController.getById);

// Rutas de trabajador/admin
router.post('/',              verifyToken, checkRole('worker', 'admin'), productoController.create);
router.put('/:id',            verifyToken, checkRole('worker', 'admin'), productoController.update);
router.put('/:id/restock',    verifyToken, checkRole('worker', 'admin'), productoController.restock);
router.delete('/:id',         verifyToken, checkRole('worker', 'admin'), productoController.remove);

module.exports = router;