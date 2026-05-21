const router = require('express').Router();
const { getByProduct, create, remove } = require('../controllers/reviews.controller');
const authenticate = require('../middlewares/authenticate');

router.get('/product/:productId', getByProduct);
router.post('/product/:productId', authenticate, create);
router.delete('/:id', authenticate, remove);

module.exports = router;