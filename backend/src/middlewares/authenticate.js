const { verify } = require('../utils/jwt');

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * AUTHENTICATION MIDDLEWARE
 * Verifica JWT en Authorization header y adjunta usuario a req.user
 * ═══════════════════════════════════════════════════════════════════════════
 */

const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    // Validate authorization header format
    if (!authHeader) {
      return res.status(401).json({
        success: false,
        error: 'Authorization header is required',
      });
    }

    if (!authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'Invalid authorization header format. Use: Bearer <token>',
      });
    }

    // Extract token
    const token = authHeader.substring(7); // Remove 'Bearer '

    if (!token || token.trim().length === 0) {
      return res.status(401).json({
        success: false,
        error: 'Token is required',
      });
    }

    // Verify token and attach user to request
    try {
      req.user = verify(token);

      // Ensure user object has required fields
      if (!req.user || !req.user.id) {
        return res.status(401).json({
          success: false,
          error: 'Invalid token payload',
        });
      }

      next();
    } catch (verifyError) {
      // Handle specific JWT errors
      if (verifyError.name === 'TokenExpiredError') {
        return res.status(401).json({
          success: false,
          error: 'Token has expired',
        });
      }

      if (verifyError.name === 'JsonWebTokenError') {
        return res.status(401).json({
          success: false,
          error: 'Invalid token',
        });
      }

      throw verifyError;
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: 'Authentication failed',
    });
  }
};

module.exports = authenticate;
