const errorHandler = (err, req, res, next) => {
  console.error(`[ERROR] ${err.message}`);

  const status = err.status || 500;
  const message = err.message || 'Error interno del servidor';

  if (err.name === 'SequelizeUniqueConstraintError') {
    return res.status(409).json({ message: 'El recurso ya existe', detail: err.errors[0]?.message });
  }

  if (err.name === 'SequelizeForeignKeyConstraintError') {
    return res.status(400).json({ message: 'Referencia inválida a un recurso relacionado' });
  }

  if (err.name === 'SequelizeValidationError') {
    return res.status(400).json({ message: 'Error de validación en base de datos', detail: err.errors[0]?.message });
  }

  return res.status(status).json({ message });
};

module.exports = { errorHandler };