const Auditoria = require('../models/auditoria.model');

const registrarAuditoria = (accion, entidad) => {
  return async (req, res, next) => {
    const originalJson = res.json.bind(res);

    res.json = async (body) => {
      if (res.statusCode >= 200 && res.statusCode < 300 && req.user) {
        try {
          await Auditoria.create({
            id_usuario: req.user.id_usuario,
            accion,
            entidad,
            detalle: JSON.stringify({
              method: req.method,
              url: req.originalUrl,
              body: req.body
            })
          });
        } catch (error) {
          console.error('[AUDITORIA] Error al registrar:', error.message);
        }
      }
      return originalJson(body);
    };

    next();
  };
};

module.exports = { registrarAuditoria };