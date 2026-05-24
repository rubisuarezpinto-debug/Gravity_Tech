const router = require('express').Router();
const favoritoController = require('../controllers/favorito.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken, checkRole('client'));

router.get('/',       favoritoController.getMisFavoritos); // ◄─ Corregido
router.post('/',      favoritoController.add);
router.delete('/:id', favoritoController.remove);

module.exports = router;