const router = require('express').Router();

router.use('/auth',       require('./auth.routes'));
router.use('/users',      require('./usuario.routes'));
router.use('/products',   require('./producto.routes'));
router.use('/categories', require('./categoria.routes'));
router.use('/cart',       require('./carrito.routes'));
router.use('/orders',     require('./orden.routes'));
router.use('/staff',      require('./staff.routes'));
router.use('/analytics',  require('./analytics.routes'));
router.use('/favorites',  require('./favorito.routes'));
router.use('/reviews',    require('./resena.routes'));
router.use('/addresses',  require('./direccion.routes'));

module.exports = router;