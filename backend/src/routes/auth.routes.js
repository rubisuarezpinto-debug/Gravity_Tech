const router = require('express').Router();
const authController = require('../controllers/auth.controller');
const { authLimiter } = require('../middlewares/rateLimit.middleware');

router.post('/register',          authLimiter, authController.register);
router.post('/verify-email',      authLimiter, authController.verifyEmail);
router.post('/login',             authLimiter, authController.login);
router.post('/forgot-password',   authLimiter, authController.forgotPassword);
router.post('/verify-reset-code', authLimiter, authController.verifyResetCode);
router.post('/reset-password',    authLimiter, authController.resetPassword);
router.post('/logout',            authController.logout); // ← se agrega logout al controller

module.exports = router;