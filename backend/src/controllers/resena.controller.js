const Resena = require('../models/resena.model');
const Usuario = require('../models/usuario.model');

const getByProducto = async (req, res, next) => {
  try {
    // CORREGIDO: Soporta tanto :productId de la ruta como :id_producto para asegurar que la app móvil no falle
    const idProductoBuscar = req.params.productId || req.params.id_producto;

    const resenas = await Resena.findAll({
      where: { id_producto: idProductoBuscar },
      include: [{ model: Usuario, as: 'usuario', attributes: ['nombre'] }],
      order: [['fecha_creacion', 'DESC']]
    });
    res.json(resenas);
  } catch (error) {
    next(error);
  }
};

const create = async (req, res, next) => {
  try {
    const { id_producto, comentario, puntuacion } = req.body;

    const existe = await Resena.findOne({ where: { id_usuario: req.user.id_usuario, id_producto } });
    if (existe) return res.status(409).json({ message: 'Ya dejaste una reseña para este producto' });

    const resena = await Resena.create({ id_usuario: req.user.id_usuario, id_producto, comentario, puntuacion });
    res.status(201).json({ message: 'Reseña creada', resena });
  } catch (error) {
    next(error);
  }
};

const remove = async (req, res, next) => {
  try {
    const resena = await Resena.findByPk(req.params.id);
    if (!resena) return res.status(404).json({ message: 'Reseña no encontrada' });

    if (resena.id_usuario !== req.user.id_usuario && req.user.rol !== 'admin') {
      return res.status(403).json({ message: 'No tienes permiso para eliminar esta reseña' });
    }

    await resena.destroy();
    res.json({ message: 'Reseña eliminada' });
  } catch (error) {
    next(error);
  }
};

module.exports = { getByProducto, create, remove };