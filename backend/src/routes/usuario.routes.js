const router = require('express').Router();
const usuarioController = require('../controllers/usuario.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

router.use(verifyToken);

router.get('/profile',          usuarioController.getProfile);
router.put('/profile',          usuarioController.updateProfile);
router.put('/change-password',  usuarioController.changePassword);

module.exports = router;