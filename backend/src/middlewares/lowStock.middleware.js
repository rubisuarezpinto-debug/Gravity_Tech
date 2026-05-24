const Producto = require('../models/producto.model');
const { Op } = require('sequelize');

const LOW_STOCK_THRESHOLD = 5;

const checkLowStock = async (req, res, next) => {
  try {
    const productosConStockBajo = await Producto.findAll({
      where: {
        stock: { [Op.lte]: LOW_STOCK_THRESHOLD },
        estado: 'DISPONIBLE'
      },
      attributes: ['id_producto', 'nombre', 'stock']
    });

    req.lowStockProducts = productosConStockBajo;
    next();
  } catch (error) {
    next(error);
  }
};

module.exports = { checkLowStock };