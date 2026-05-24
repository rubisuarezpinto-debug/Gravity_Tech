const { sequelize } = require('../config/database');
const Orden = require('../models/orden.model');
const OrdenItem = require('../models/ordenItem.model');
const Carrito = require('../models/carrito.model');
const CarritoItem = require('../models/carritoItem.model');
const Producto = require('../models/producto.model');
const Pago = require('../models/pago.model');
const EstadoOrden = require('../models/estadoOrden.model');

const checkout = async (req, res, next) => {
  const t = await sequelize.transaction();
  try {
    const { id_direccion, id_metodo_pago, id_tipo_envio } = req.body;

    const carrito = await Carrito.findOne({
      where: { id_usuario: req.user.id_usuario, estado: 'ABIERTO' },
      include: [{ model: CarritoItem, as: 'items' }],
      transaction: t
    });

    if (!carrito || carrito.items.length === 0) {
      await t.rollback();
      return res.status(400).json({ message: 'El carrito está vacío' });
    }

    let total = 0;
    for (const item of carrito.items) {
      const producto = await Producto.findByPk(item.id_producto, { transaction: t });
      if (producto.stock < item.cantidad) {
        await t.rollback();
        return res.status(400).json({ message: `Stock insuficiente para: ${producto.nombre}` });
      }
      total += parseFloat(item.precio_unitario) * item.cantidad;
    }

    const orden = await Orden.create({
      id_usuario: req.user.id_usuario, id_direccion, id_metodo_pago,
      id_tipo_envio, id_estado: 1, total: total.toFixed(2)
    }, { transaction: t });

    for (const item of carrito.items) {
      await OrdenItem.create({
        id_orden: orden.id_orden, id_producto: item.id_producto,
        cantidad: item.cantidad, precio_unitario: item.precio_unitario
      }, { transaction: t });

      await Producto.decrement('stock', { by: item.cantidad, where: { id_producto: item.id_producto }, transaction: t });
    }

    await Pago.create({
      id_orden: orden.id_orden, monto: total.toFixed(2), estado: 'PENDIENTE'
    }, { transaction: t });

    await carrito.update({ estado: 'CERRADO' }, { transaction: t });

    await t.commit();
    res.status(201).json({ message: 'Orden creada exitosamente', id_orden: orden.id_orden, total: total.toFixed(2) });
  } catch (error) {
    await t.rollback();
    next(error);
  }
};

const getMisOrdenes = async (req, res, next) => {
  try {
    const ordenes = await Orden.findAll({
      where: { id_usuario: req.user.id_usuario },
      include: [
        { model: EstadoOrden, as: 'estado' },
        { model: OrdenItem, as: 'items',
          include: [{ model: Producto, as: 'producto', attributes: ['nombre', 'precio'] }]
        }
      ],
      order: [['fecha_orden', 'DESC']]
    });
    res.json(ordenes);
  } catch (error) {
    next(error);
  }
};

const getById = async (req, res, next) => {
  try {
    const orden = await Orden.findOne({
      where: { id_orden: req.params.id, id_usuario: req.user.id_usuario },
      include: [
        { model: EstadoOrden, as: 'estado' },
        { model: OrdenItem, as: 'items',
          include: [{ model: Producto, as: 'producto' }]
        }
      ]
    });
    if (!orden) return res.status(404).json({ message: 'Orden no encontrada' });
    res.json(orden);
  } catch (error) {
    next(error);
  }
};

const updateEstado = async (req, res, next) => {
  try {
    const orden = await Orden.findByPk(req.params.id);
    if (!orden) return res.status(404).json({ message: 'Orden no encontrada' });

    await orden.update({ id_estado: req.body.id_estado });
    res.json({ message: 'Estado de orden actualizado' });
  } catch (error) {
    next(error);
  }
};

module.exports = { checkout, getMisOrdenes, getById, updateEstado };