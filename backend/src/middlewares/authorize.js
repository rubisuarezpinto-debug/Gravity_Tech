/**
 * ═══════════════════════════════════════════════════════════════════════════
 * AUTHORIZATION MIDDLEWARE (RBAC - Role-Based Access Control)
 * Fábrica que devuelve middleware para verificar roles de usuario
 *
 * @param {...string} roles - Roles permitidos. Ej: authorize('admin', 'manager')
 * @returns {Function} Middleware function
 * ═══════════════════════════════════════════════════════════════════════════
 */

const authorize = (...roles) => (req, res, next) => {
  try {
    // Check if user is authenticated
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: 'Authentication required',
      });
    }

    // Validate that roles array is not empty
    if (!roles || roles.length === 0) {
      console.warn('⚠️  authorize() called with no roles');
      return res.status(500).json({
        success: false,
        error: 'Server configuration error',
      });
    }

    // Check if user has required role
    const userRole = req.user.rol;

    if (!userRole) {
      return res.status(403).json({
        success: false,
        error: 'No role assigned to user',
      });
    }

    if (!roles.includes(userRole)) {
      // Log unauthorized access attempt
      console.warn(`[SECURITY] Unauthorized access attempt - User ${req.user.id} with role '${userRole}' tried to access protected resource. Required roles: [${roles.join(', ')}]`);

      return res.status(403).json({
        success: false,
        error: 'Insufficient permissions to access this resource',
      });
    }

    // User is authorized
    next();
  } catch (error) {
    console.error('Authorization middleware error:', error.message);
    return res.status(500).json({
      success: false,
      error: 'Authorization check failed',
    });
  }
};

module.exports = authorize;
