const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { sign } = require('../utils/jwt');
const { hash } = require('../utils/hash');
const { sanitizeUser, createSafeResponse } = require('../utils/sanitizer');
const { sendPasswordReset } = require('../services/email.service');

const RESET_SECRET_SUFFIX = '_reset';

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * POST /api/auth/register - Register a new user
 * ═══════════════════════════════════════════════════════════════════════════
 */
const register = async (req, res, next) => {
  try {
    // req.body is already validated by validateRequest middleware
    const { email, password, name } = req.body;

    // Check if email already exists
    const existing = await User.findByEmail(email);
    if (existing) {
      return res.status(409).json({
        success: false,
        error: 'Este correo ya está registrado',
      });
    }

    // Create new user
    const user = await User.create(name, email, password);

    // Generate JWT token
    const token = sign({ id: user.id, rol: user.rol });

    // Sanitize user object before sending
    const safeUser = sanitizeUser(user);

    return res.status(201).json({
      success: true,
      data: {
        user: safeUser,
        token,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * POST /api/auth/login - Authenticate user with email and password
 * ═══════════════════════════════════════════════════════════════════════════
 */
const login = async (req, res, next) => {
  try {
    // req.body is already validated by validateRequest middleware
    const { email, password } = req.body;

    // Find user by email
    const user = await User.findByEmail(email);
    if (!user) {
      // Use generic message to prevent email enumeration attacks
      return res.status(401).json({
        success: false,
        error: 'Correo o contraseña incorrectos',
      });
    }

    // Verify password
    const valid = await User.verifyPassword(password, user.password_hash);
    if (!valid) {
      // Use same generic message for both cases
      return res.status(401).json({
        success: false,
        error: 'Correo o contraseña incorrectos',
      });
    }

    // Generate JWT token
    const token = sign({ id: user.id, rol: user.rol });

    // Sanitize user object before sending
    const safeUser = sanitizeUser(user);

    return res.json({
      success: true,
      data: {
        user: safeUser,
        token,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * GET /api/auth/me - Get current authenticated user
 * ═══════════════════════════════════════════════════════════════════════════
 */
const me = async (req, res, next) => {
  try {
    // req.user is set by authenticate middleware
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'Usuario no encontrado',
      });
    }

    // Sanitize user object before sending
    const safeUser = sanitizeUser(user);

    return res.json({
      success: true,
      data: {
        user: safeUser,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * POST /api/auth/forgot-password - Envía email con link de reset
 * ═══════════════════════════════════════════════════════════════════════════
 */
const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    const user = await User.findByEmail(email);

    // Respuesta genérica siempre — no revelar si el email existe
    const response = {
      success: true,
      message: 'Si ese correo está registrado, recibirás el enlace en breve.',
    };

    if (!user) return res.json(response);

    const passwordHash = await User.getPasswordHash(user.id);

    // El token expira en 1h y se invalida automáticamente al cambiar la contraseña
    const resetSecret = process.env.JWT_SECRET + passwordHash + RESET_SECRET_SUFFIX;
    const token = jwt.sign({ id: user.id }, resetSecret, { expiresIn: '1h' });

    const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
    const link = `${frontendUrl}/reset-password.html?token=${token}`;

    await sendPasswordReset(email, user.nombre || 'Usuario', link);

    return res.json(response);
  } catch (error) {
    next(error);
  }
};

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * POST /api/auth/reset-password - Actualiza la contraseña con el token
 * ═══════════════════════════════════════════════════════════════════════════
 */
const resetPassword = async (req, res, next) => {
  try {
    const { token, password } = req.body;

    // Decodificar sin verificar para obtener el id primero
    let decoded;
    try {
      decoded = jwt.decode(token);
    } catch {
      return res.status(400).json({ success: false, error: 'Token inválido.' });
    }

    if (!decoded?.id) {
      return res.status(400).json({ success: false, error: 'Token inválido.' });
    }

    const passwordHash = await User.getPasswordHash(decoded.id);
    if (!passwordHash) {
      return res.status(400).json({ success: false, error: 'Token inválido.' });
    }

    // Verificar con el secret que incluye el hash actual
    const resetSecret = process.env.JWT_SECRET + passwordHash + RESET_SECRET_SUFFIX;
    try {
      jwt.verify(token, resetSecret);
    } catch {
      return res.status(400).json({ success: false, error: 'El enlace expiró o ya fue usado.' });
    }

    const newHash = await hash(password);
    await User.updatePassword(decoded.id, newHash);

    return res.json({ success: true, message: 'Contraseña actualizada correctamente.' });
  } catch (error) {
    next(error);
  }
};

module.exports = { register, login, me, forgotPassword, resetPassword };
