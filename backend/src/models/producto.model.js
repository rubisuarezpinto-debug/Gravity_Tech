const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Producto = sequelize.define('producto', {
  id_producto: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nombre: { type: DataTypes.STRING(200), allowNull: false },
  descripcion: { type: DataTypes.TEXT },
  precio: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
  stock: { type: DataTypes.INTEGER, defaultValue: 0 },
  sku: { type: DataTypes.STRING(50) },
  id_marca: { type: DataTypes.INTEGER, allowNull: false },
  estado: { type: DataTypes.STRING(20), defaultValue: 'DISPONIBLE' },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  fecha_actualizacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'producto',
  timestamps: false
});

module.exports = Producto;