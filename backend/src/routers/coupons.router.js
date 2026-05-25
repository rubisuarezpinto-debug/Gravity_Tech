const router = require('express').Router();
const { validate, getAll, create, toggle } = require('../controllers/coupons.controller');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');
const { body, param } = require('express-validator');
const validateRequest = require('../validators/middleware');

const validateCouponSchema = [
  body('codigo').trim().notEmpty().withMessage('El código es requerido'),
];

const createCouponSchema = [
  body('codigo').trim().notEmpty().withMessage('El código es requerido'),
  body('discount_pct')
    .isFloat({ min: 0.01, max: 100 })
    .withMessage('El descuento debe estar entre 0.01 y 100'),
  body('fecha_expiracion')
    .optional()
    .isISO8601()
    .withMessage('Fecha de expiración inválida'),
];

const idSchema = [
  param('id').isInt({ min: 1 }).withMessage('ID inválido').toInt(),
];

// Público: validar cupón (lo usa el checkout)
router.post('/validate', validateCouponSchema, validateRequest, validate);

// Admin: gestión de cupones
router.get('/',       authenticate, authorize('admin'), getAll);
router.post('/',      authenticate, authorize('admin'), createCouponSchema, validateRequest, create);
router.patch('/:id',  authenticate, authorize('admin'), idSchema, validateRequest, toggle);

module.exports = router;
