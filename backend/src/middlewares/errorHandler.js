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
  400: 'Bad request',
  401: 'Unauthorized',
  403: 'Forbidden',
  404: 'Not found',
  409: 'Conflict',
  422: 'Unprocessable entity',
  500: 'Internal server error',
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
    clientMessage = safeErrorMessages[statusCode] || 'An unexpected error occurred';
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
