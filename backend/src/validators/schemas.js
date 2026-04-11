/**
 * ═══════════════════════════════════════════════════════════════════════════
 * VALIDATION SCHEMAS
 * Define request validation rules para todos los endpoints
 * ═══════════════════════════════════════════════════════════════════════════
 */

const { body, param, query } = require('express-validator');

// ─── Auth Validation Schemas ────────────────────────────────────────────────

const registerSchema = [
  body('email')
    .trim()
    .isEmail()
    .normalizeEmail()
    .withMessage('Email must be a valid email address'),

  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long')
    .matches(/[A-Z]/)
    .withMessage('Password must contain at least one uppercase letter')
    .matches(/[a-z]/)
    .withMessage('Password must contain at least one lowercase letter')
    .matches(/[0-9]/)
    .withMessage('Password must contain at least one number')
    .matches(/[!@#$%^&*(),.?":{}|<>]/)
    .withMessage('Password must contain at least one special character'),

  body('first_name')
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('First name must be between 2 and 50 characters')
    .matches(/^[a-zA-ZáéíóúñÁÉÍÓÚÑ\s-]+$/)
    .withMessage('First name can only contain letters, spaces, and hyphens'),

  body('last_name')
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('Last name must be between 2 and 50 characters')
    .matches(/^[a-zA-ZáéíóúñÁÉÍÓÚÑ\s-]+$/)
    .withMessage('Last name can only contain letters, spaces, and hyphens'),
];

const loginSchema = [
  body('email')
    .trim()
    .isEmail()
    .normalizeEmail()
    .withMessage('Email must be a valid email address'),

  body('password')
    .notEmpty()
    .withMessage('Password is required')
    .isLength({ min: 8 })
    .withMessage('Invalid credentials'),
];

// ─── Product Validation Schemas ─────────────────────────────────────────────

const createProductSchema = [
  body('name')
    .trim()
    .isLength({ min: 3, max: 255 })
    .withMessage('Product name must be between 3 and 255 characters')
    .matches(/^[a-zA-Z0-9áéíóúñÁÉÍÓÚÑ\s\-()]+$/)
    .withMessage('Product name contains invalid characters'),

  body('description')
    .trim()
    .isLength({ min: 10, max: 2000 })
    .withMessage('Description must be between 10 and 2000 characters'),

  body('price')
    .isFloat({ min: 0.01 })
    .withMessage('Price must be a positive number greater than 0')
    .toFloat(),

  body('stock')
    .isInt({ min: 0 })
    .withMessage('Stock must be a non-negative integer')
    .toInt(),

  body('category_id')
    .isInt({ min: 1 })
    .withMessage('Category ID must be a positive integer')
    .toInt(),
];

const updateProductSchema = [
  body('name')
    .optional()
    .trim()
    .isLength({ min: 3, max: 255 })
    .withMessage('Product name must be between 3 and 255 characters'),

  body('description')
    .optional()
    .trim()
    .isLength({ min: 10, max: 2000 })
    .withMessage('Description must be between 10 and 2000 characters'),

  body('price')
    .optional()
    .isFloat({ min: 0.01 })
    .withMessage('Price must be a positive number'),

  body('stock')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Stock must be a non-negative integer'),
];

// ─── Cart Validation Schemas ────────────────────────────────────────────────

const addToCartSchema = [
  body('product_id')
    .isInt({ min: 1 })
    .withMessage('Product ID must be a positive integer')
    .toInt(),

  body('quantity')
    .isInt({ min: 1, max: 999 })
    .withMessage('Quantity must be between 1 and 999')
    .toInt(),
];

const updateCartItemSchema = [
  param('id')
    .isInt({ min: 1 })
    .withMessage('Item ID must be a positive integer')
    .toInt(),

  body('quantity')
    .isInt({ min: 1, max: 999 })
    .withMessage('Quantity must be between 1 and 999')
    .toInt(),
];

// ─── Order Validation Schemas ───────────────────────────────────────────────

const checkoutSchema = [
  body('shipping_address')
    .trim()
    .isLength({ min: 5, max: 500 })
    .withMessage('Shipping address must be between 5 and 500 characters'),

  body('payment_method_id')
    .isInt({ min: 1 })
    .withMessage('Payment method ID must be a positive integer')
    .toInt(),

  body('notes')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Notes must not exceed 1000 characters'),
];

// ─── Review Validation Schemas ──────────────────────────────────────────────

const createReviewSchema = [
  body('product_id')
    .isInt({ min: 1 })
    .withMessage('Product ID must be a positive integer')
    .toInt(),

  body('rating')
    .isInt({ min: 1, max: 5 })
    .withMessage('Rating must be between 1 and 5')
    .toInt(),

  body('comment')
    .trim()
    .isLength({ min: 10, max: 1000 })
    .withMessage('Comment must be between 10 and 1000 characters'),
];

// ─── ID Validation Schemas ──────────────────────────────────────────────────

const idParamSchema = [
  param('id')
    .isInt({ min: 1 })
    .withMessage('ID must be a positive integer')
    .toInt(),
];

module.exports = {
  registerSchema,
  loginSchema,
  createProductSchema,
  updateProductSchema,
  addToCartSchema,
  updateCartItemSchema,
  checkoutSchema,
  createReviewSchema,
  idParamSchema,
};
