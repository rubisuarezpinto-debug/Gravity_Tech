const router = require('express').Router();
const direccionController = require('../controllers/direccion.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken, checkRole('client'));

// CORREGIDO: Ajustados los nombres para que coincidan exactamente con tu controlador
router.get('/',       direccionController.getMisDirecciones); // ◄─ Cambiado de getAll a getMisDirecciones
router.post('/',      direccionController.create);            // ◄─ Cambiado de add a create
router.put('/:id',    direccionController.update);
router.delete('/:id', direccionController.remove);

module.exports = router;