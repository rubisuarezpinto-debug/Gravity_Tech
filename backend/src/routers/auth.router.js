const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { register, login, verifySms, solicitarRecuperacion, cambiarContrasenia } = require('../controllers/auth.controller');

// POST /api/auth/register
router.post('/register', authController.register);

// POST /api/auth/verify-sms
router.post('/verify-sms', authController.verifySms);

// POST /api/auth/login
router.post('/login', authController.login);

router.post('/forgot-password', solicitarRecuperacion);
router.post('/reset-password', cambiarContrasenia);

module.exports = router;