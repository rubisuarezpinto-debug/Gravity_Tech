const securityConfig = require('../config/security');

const safeErrorMessages = {
  400: 'Solicitud inválida',
  401: 'No autorizado. Por favor inicia sesión',
  403: 'No tienes permiso para realizar esta acción',
  404: 'El recurso solicitado no existe',
  409: 'Ya existe un registro con esos datos',
  422: 'Los datos enviados no son válidos',
  500: 'Ocurrió un error en el servidor. Intenta nuevamente',
};

const errorHandler = (err, req, res, _next) => {
  let statusCode = err.statusCode || err.status || 500;
  if (statusCode < 400 || statusCode >= 600) {
    statusCode = 500;
  }

  const logError = {
    timestamp: new Date().toISOString(),
    statusCode,
    path: req.path,
    method: req.method,
    message: err.message,
    ...(securityConfig.isDevelopment && { stack: err.stack }),
  };
  console.error('[ErrorHandler]', JSON.stringify(logError));

  let clientMessage = err.message;

  if (securityConfig.isProduction && statusCode >= 500) {
    clientMessage = safeErrorMessages[statusCode] || 'Ocurrió un error inesperado. Intenta nuevamente';
  }

  if (clientMessage && typeof clientMessage === 'string') {
    clientMessage = clientMessage
      .replace(/\/[\w/\-_.]*\.js:\d+:\d+/g, '[internal]')
      .replace(/password/gi, '[REDACTED]')
      .replace(/token/gi, '[REDACTED]')
      .replace(/secret/gi, '[REDACTED]')
      .replace(/api.?key/gi, '[REDACTED]');
  }

  if (securityConfig.isDevelopment) {
    return res.status(statusCode).json({
      message: clientMessage || safeErrorMessages[statusCode],
      statusCode,
      timestamp: new Date().toISOString(),
      ...(err.details && { details: err.details })
    });
  }

  res.status(statusCode).json({
    message: clientMessage || safeErrorMessages[statusCode]
  });
};

module.exports = errorHandler;