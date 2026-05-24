const Favorito = require('../models/favorito.model');
const Producto = require('../models/producto.model');
const Imagen = require('../models/imagen.model');

const getMisFavoritos = async (req, res, next) => {
  try {
    const favoritos = await Favorito.findAll({
      where: { id_usuario: req.user.id_usuario },
      include: [{
        model: Producto, as: 'producto',
        include: [{ model: Imagen, as: 'imagenes', where: { es_principal: true }, required: false }]
      }]
    });
    res.json(favoritos);
  } catch (error) {
    next(error);
  }
};

const add = async (req, res, next) => {
  try {
    const { id_producto } = req.body;

    const producto = await Producto.findByPk(id_producto);
    if (!producto) return res.status(404).json({ message: 'Producto no encontrado' });

    const existe = await Favorito.findOne({ where: { id_usuario: req.user.id_usuario, id_producto } });
    if (existe) return res.status(409).json({ message: 'El producto ya está en favoritos' });

    await Favorito.create({ id_usuario: req.user.id_usuario, id_producto });
    res.status(201).json({ message: 'Producto agregado a favoritos' });
  } catch (error) {
    next(error);
  }
};

const remove = async (req, res, next) => {
  try {
    // CORREGIDO: Soporta tanto :id de la ruta como :id_producto para asegurar el proceso
    const idBuscar = req.params.id || req.params.id_producto;

    const favorito = await Favorito.findOne({
      where: { id_usuario: req.user.id_usuario, id_producto: idBuscar }
    });
    if (!favorito) return res.status(404).json({ message: 'Favorito no encontrado' });

    await favorito.destroy();
    res.json({ message: 'Producto eliminado de favoritos' });
  } catch (error) {
    next(error);
  }
};

module.exports = { getMisFavoritos, add, remove };