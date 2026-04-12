/**
 * ═══════════════════════════════════════════════════════════════════════════
 * GLOBAL ERROR HANDLER MIDDLEWARE
 * Maneja todos los errores de manera segura sin exponer información sensible
 * DEBE REGISTRARSE ÚLTIMO en app.js (después de todas las rutas)
 * ═══════════════════════════════════════════════════════════════════════════
 */

const securityConfig = require('../config/security');

// Map of safe error messages for production
const safeErrorMessages = {
  400: 'Solicitud inválida',
  401: 'No autorizado. Por favor inicia sesión',
  403: 'No tienes permiso para realizar esta acción',
  404: 'El recurso solicitado no existe',
  409: 'Ya existe un registro con esos datos',
  422: 'Los datos enviados no son válidos',
  500: 'Ocurrió un error en el servidor. Intenta nuevamente',
};

// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, _next) => {
  // Determine status code
  let statusCode = err.statusCode || err.status || 500;
  if (statusCode < 400 || statusCode >= 600) {
    statusCode = 500;
  }

  // Log error (with sensitive data filtered)
  const logError = {
    timestamp: new Date().toISOString(),
    statusCode,
    path: req.path,
    method: req.method,
    message: err.message,
    ...(securityConfig.isDevelopment && { stack: err.stack }),
  };
  console.error('[ErrorHandler]', JSON.stringify(logError));

  // Determine message to send to client
  let clientMessage = err.message;

  // In production, use safe generic messages for server errors
  if (securityConfig.isProduction && statusCode >= 500) {
    clientMessage = safeErrorMessages[statusCode] || 'Ocurrió un error inesperado. Intenta nuevamente';
  }

  // Ensure we never leak sensitive data
  if (clientMessage && typeof clientMessage === 'string') {
    // Remove stack traces, file paths, database connection strings, etc.
    clientMessage = clientMessage
      .replace(/\/[\w/\-_.]*\.js:\d+:\d+/g, '[internal]')
      .replace(/password/gi, '[REDACTED]')
      .replace(/token/gi, '[REDACTED]')
      .replace(/secret/gi, '[REDACTED]')
      .replace(/api.?key/gi, '[REDACTED]');
  }

  // Build response
  const response = {
    success: false,
    error: clientMessage || safeErrorMessages[statusCode],
  };

  // Add helpful information only in development
  if (securityConfig.isDevelopment) {
    response.details = {
      statusCode,
      timestamp: new Date().toISOString(),
    };
    if (err.details) {
      response.details = { ...response.details, ...err.details };
    }
  }

  // Send response
  res.status(statusCode).json(response);
};

module.exports = errorHandler;
