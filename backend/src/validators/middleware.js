/**
 * ═══════════════════════════════════════════════════════════════════════════
 * VALIDATION MIDDLEWARE
 * Ejecuta validaciones y retorna errores de manera segura
 * ═══════════════════════════════════════════════════════════════════════════
 */

const { validationResult } = require('express-validator');

/**
 * Middleware que ejecuta validaciones y retorna errores formateados
 * IMPORTANTE: Debe colocarse después de las validaciones en express-validator
 */
const validateRequest = (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    // Format errors for client
    const formattedErrors = errors.array().reduce((acc, error) => {
      const field = error.param || error.location || 'unknown';
      if (!acc[field]) {
        acc[field] = [];
      }
      acc[field].push(error.msg);
      return acc;
    }, {});

    return res.status(422).json({
      success: false,
      error: 'Validation failed',
      details: formattedErrors,
    });
  }

  next();
};

module.exports = validateRequest;
