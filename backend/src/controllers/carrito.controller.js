const Carrito = require('../models/carrito.model');
const CarritoItem = require('../models/carritoItem.model');
const Producto = require('../models/producto.model');
const Imagen = require('../models/imagen.model');

const getCarrito = async (req, res, next) => {
  try {
    let carrito = await Carrito.findOne({
      where: { id_usuario: req.user.id_usuario, estado: 'ABIERTO' },
      include: [{
        model: CarritoItem, as: 'items',
        include: [{
          model: Producto, as: 'producto',
          attributes: ['id_producto', 'nombre', 'precio', 'stock'],
          include: [{ model: Imagen, as: 'imagenes', where: { es_principal: true }, required: false }]
        }]
      }]
    });

    if (!carrito) {
      carrito = await Carrito.create({ id_usuario: req.user.id_usuario });
      carrito.items = [];
    }

    const total = (carrito.items || []).reduce((sum, item) => sum + parseFloat(item.precio_unitario) * item.cantidad, 0);
    res.json({ carrito, total: total.toFixed(2) });
  } catch (error) {
    next(error);
  }
};

const addItem = async (req, res, next) => {
  try {
    const id_producto = req.body.id_producto || req.body.product_id;
    const cantidad = req.body.cantidad ?? 1;

    const producto = await Producto.findByPk(id_producto);
    if (!producto) return res.status(404).json({ message: 'Producto no encontrado' });
    if (producto.stock < cantidad) return res.status(400).json({ message: 'Stock insuficiente' });

    let carrito = await Carrito.findOne({ where: { id_usuario: req.user.id_usuario, estado: 'ABIERTO' } });
    if (!carrito) carrito = await Carrito.create({ id_usuario: req.user.id_usuario });

    const itemExistente = await CarritoItem.findOne({ where: { id_carrito: carrito.id_carrito, id_producto } });

    if (itemExistente) {
      await itemExistente.update({ cantidad: itemExistente.cantidad + cantidad });
    } else {
      await CarritoItem.create({ id_carrito: carrito.id_carrito, id_producto, cantidad, precio_unitario: producto.precio });
    }

    await carrito.update({ fecha_actualizacion: new Date() });
    res.json({ message: 'Producto agregado al carrito' });
  } catch (error) {
    next(error);
  }
};

const clearCart = async (req, res, next) => {
  try {
    const carrito = await Carrito.findOne({ where: { id_usuario: req.user.id_usuario, estado: 'ABIERTO' } });
    if (!carrito) return res.json({ message: 'Carrito vacío' });

    await CarritoItem.destroy({ where: { id_carrito: carrito.id_carrito } });
    res.json({ message: 'Carrito vaciado' });
  } catch (error) {
    next(error);
  }
};

const updateItem = async (req, res, next) => {
  try {
    // CORREGIDO: Busca el ID desde el body enviado por el cliente para no romper tu frontend
    const { cantidad, itemId, id_item } = req.body;
    const idBuscar = itemId || id_item || req.params.itemId;

    const item = await CarritoItem.findByPk(idBuscar);
    if (!item) return res.status(404).json({ message: 'Item no encontrado' });

    if (cantidad <= 0) {
      await item.destroy();
      return res.json({ message: 'Item eliminado del carrito' });
    }

    await item.update({ cantidad });
    res.json({ message: 'Cantidad actualizada', item });
  } catch (error) {
    next(error);
  }
};

const removeItem = async (req, res, next) => {
  try {
    const item = await CarritoItem.findByPk(req.params.itemId);
    if (!item) return res.status(404).json({ message: 'Item no encontrado' });

    await item.destroy();
    res.json({ message: 'Item eliminado del carrito' });
  } catch (error) {
    next(error);
  }
};

module.exports = { getCarrito, addItem, updateItem, removeItem, clearCart };