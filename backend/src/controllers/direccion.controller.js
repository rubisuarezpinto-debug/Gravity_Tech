const Direccion = require('../models/direccion.model');

const getMisDirecciones = async (req, res, next) => {
  try {
    const direcciones = await Direccion.findAll({ where: { id_usuario: req.user.id_usuario } });
    res.json(direcciones);
  } catch (error) {
    next(error);
  }
};

const create = async (req, res, next) => {
  try {
    const { direccion, ciudad, pais, latitud, longitud } = req.body;
    const nueva = await Direccion.create({ id_usuario: req.user.id_usuario, direccion, ciudad, pais, latitud, longitud });
    res.status(201).json({ message: 'Dirección agregada', direccion: nueva });
  } catch (error) {
    next(error);
  }
};

const update = async (req, res, next) => {
  try {
    const dir = await Direccion.findOne({ where: { id_direccion: req.params.id, id_usuario: req.user.id_usuario } });
    if (!dir) return res.status(404).json({ message: 'Dirección no encontrada' });

    await dir.update(req.body);
    res.json({ message: 'Dirección actualizada', direccion: dir });
  } catch (error) {
    next(error);
  }
};

const remove = async (req, res, next) => {
  try {
    const dir = await Direccion.findOne({ where: { id_direccion: req.params.id, id_usuario: req.user.id_usuario } });
    if (!dir) return res.status(404).json({ message: 'Dirección no encontrada' });

    await dir.destroy();
    res.json({ message: 'Dirección eliminada' });
  } catch (error) {
    next(error);
  }
};

module.exports = { getMisDirecciones, create, update, remove };