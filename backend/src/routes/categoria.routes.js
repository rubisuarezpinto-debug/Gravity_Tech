const router = require('express').Router();
const categoriaController = require('../controllers/categoria.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.get('/',       verifyToken, categoriaController.getAll);
router.get('/:id',    verifyToken, categoriaController.getById);
router.post('/',      verifyToken, checkRole('admin'), categoriaController.create);
router.put('/:id',    verifyToken, checkRole('admin'), categoriaController.update);
router.delete('/:id', verifyToken, checkRole('admin'), categoriaController.remove);

module.exports = router;