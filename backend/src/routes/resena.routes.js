const router = require('express').Router();
const resenaController = require('../controllers/resena.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken);

router.get('/product/:productId',  resenaController.getByProducto); // ◄─ Corregido
router.post('/',                    checkRole('client'), resenaController.create);
router.delete('/:id',              checkRole('client', 'admin'), resenaController.remove);

module.exports = router;