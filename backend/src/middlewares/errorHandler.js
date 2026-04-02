/**
 * Manejador global de errores de Express.
 * Debe registrarse ÚLTIMO en app.js (después de todas las rutas).
 */
// eslint-disable-next-line no-unused-vars
const errorHandler = (err, _req, res, _next) => {
  console.error('[ErrorHandler]', err);

  const statusCode = err.statusCode || err.status || 500;
  const message = err.message || 'Error interno del servidor';

  res.status(statusCode).json({
    success: false,
    message,
    // Solo mostrar stack en desarrollo
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};

module.exports = errorHandler;
