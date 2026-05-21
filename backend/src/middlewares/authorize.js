const authorize = (...roles) => (req, res, next) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }

    if (!roles || roles.length === 0) {
      console.warn('⚠️ authorize() called with no roles');
      return res.status(500).json({ message: 'Server configuration error' });
    }

const userRole = req.user.role || req.user.rol;
    if (!userRole) {
      return res.status(403).json({ message: 'No role assigned to user' });
    }

    if (!roles.includes(userRole)) {
      console.warn(`[SECURITY] Unauthorized access attempt - User ${req.user.id} with role '${userRole}' tried to access protected resource. Required roles: [${roles.join(', ')}]`);
      return res.status(403).json({ message: 'Insufficient permissions to access this resource' });
    }

    next();
  } catch (error) {
    console.error('Authorization middleware error:', error.message);
    return res.status(500).json({ message: 'Authorization check failed' });
  }
};

module.exports = authorize;