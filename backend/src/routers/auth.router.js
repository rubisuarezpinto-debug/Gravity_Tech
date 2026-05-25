const router = require('express').Router();
const { register, login, me, forgotPassword, resetPassword } = require('../controllers/auth.controller');
const authenticate = require('../middlewares/authenticate');
const validateRequest = require('../validators/middleware');
const { registerSchema, loginSchema, forgotPasswordSchema, resetPasswordSchema } = require('../validators/schemas');
const { authLimiter, registerLimiter, forgotPasswordLimiter } = require('../middlewares/rateLimiter');

router.post('/register', registerLimiter, registerSchema, validateRequest, register);
router.post('/login', authLimiter, loginSchema, validateRequest, login);
router.get('/me', authenticate, me);
router.post('/forgot-password', forgotPasswordLimiter, forgotPasswordSchema, validateRequest, forgotPassword);
router.post('/reset-password', resetPasswordSchema, validateRequest, resetPassword);

module.exports = router;
