const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const CarritoItem = sequelize.define('carrito_item', {
  id_carrito_item: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_carrito: { type: DataTypes.INTEGER, allowNull: false },
  id_producto: { type: DataTypes.INTEGER, allowNull: false },
  cantidad: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 1 },
  precio_unitario: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'carrito_item',
  timestamps: false
});

module.exports = CarritoItem;