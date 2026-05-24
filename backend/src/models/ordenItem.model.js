const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const OrdenItem = sequelize.define('orden_item', {
  id_orden_item: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_orden: { type: DataTypes.INTEGER, allowNull: false },
  id_producto: { type: DataTypes.INTEGER, allowNull: false },
  cantidad: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 1 },
  precio_unitario: { type: DataTypes.DECIMAL(10, 2), allowNull: false }
}, {
  schema: 'ecommerce',
  tableName: 'orden_item',
  timestamps: false
});

module.exports = OrdenItem;