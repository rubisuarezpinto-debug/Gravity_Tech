const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const ProductoCategoria = sequelize.define('producto_categoria', {
  id_producto: { type: DataTypes.INTEGER, primaryKey: true },
  id_categoria: { type: DataTypes.INTEGER, primaryKey: true }
}, {
  schema: 'ecommerce',
  tableName: 'producto_categoria',
  timestamps: false
});

module.exports = ProductoCategoria;