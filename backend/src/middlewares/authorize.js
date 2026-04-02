/**
 * Fábrica de middleware RBAC.
 * Recibe los roles permitidos y devuelve un middleware que verifica
 * que req.user.role sea uno de ellos.
 *
 * @param {...string} roles  - Ej: authorize('admin') o authorize('admin','cliente')
 */
const authorize = (...roles) => (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ message: 'No autenticado' });
  }

  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ message: 'Acceso denegado: rol insuficiente' });
  }

  next();
};

module.exports = authorize;
