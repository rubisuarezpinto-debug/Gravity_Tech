const User = require('../models/User');
const { sign } = require('../utils/jwt');
const { sanitizeUser, createSafeResponse } = require('../utils/sanitizer');

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
    const token = sign({ id: user.id, role: user.role });

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
    const token = sign({ id: user.id, role: user.role });

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

module.exports = { register, login, me };
