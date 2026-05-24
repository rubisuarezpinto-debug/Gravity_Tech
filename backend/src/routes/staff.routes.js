const router = require('express').Router();
const staffController = require('../controllers/staff.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { checkRole } = require('../middlewares/roles.middleware');

router.use(verifyToken, checkRole('admin'));

router.get('/',       staffController.getAll);
router.post('/',      staffController.create);
router.put('/:id',    staffController.update);
router.delete('/:id', staffController.remove);

module.exports = router;