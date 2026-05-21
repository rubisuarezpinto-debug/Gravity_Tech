const { verify } = require('../utils/jwt');

const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return res.status(401).json({ message: 'Authorization header is required' });
    }

    if (!authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Invalid authorization header format. Use: Bearer <token>' });
    }

    const token = authHeader.substring(7);

    if (!token || token.trim().length === 0) {
      return res.status(401).json({ message: 'Token is required' });
    }

    try {
      req.user = verify(token);

      if (!req.user || !req.user.id) {
        return res.status(401).json({ message: 'Invalid token payload' });
      }

      next();
    } catch (verifyError) {
      if (verifyError.name === 'TokenExpiredError') {
        return res.status(401).json({ message: 'Token has expired' });
      }

      if (verifyError.name === 'JsonWebTokenError') {
        return res.status(401).json({ message: 'Invalid token' });
      }

      throw verifyError;
    }
  } catch (error) {
    console.error('Authentication error:', error.message);
    return res.status(500).json({ message: 'Authentication failed' });
  }
};

module.exports = authenticate;