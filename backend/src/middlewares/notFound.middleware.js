const notFound = (req, res, next) => {
  res.status(404).json({
    message: `Ruta no encontrada: ${req.method} ${req.originalUrl}`
  });
};

module.exports = { notFound };