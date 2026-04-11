const router = require('express').Router();
const { register, login, me } = require('../controllers/auth.controller');
const authenticate = require('../middlewares/authenticate');
const validateRequest = require('../validators/middleware');
const { registerSchema, loginSchema } = require('../validators/schemas');
const { authLimiter, registerLimiter } = require('../middlewares/rateLimiter');

router.post('/register', registerLimiter, registerSchema, validateRequest, register);
router.post('/login', authLimiter, loginSchema, validateRequest, login);
router.get('/me', authenticate, me);

module.exports = router;
