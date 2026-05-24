const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Carrito = sequelize.define('carrito', {
  id_carrito: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_usuario: { type: DataTypes.INTEGER, allowNull: false },
  estado: { type: DataTypes.STRING(20), defaultValue: 'ABIERTO' },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  fecha_actualizacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'carrito',
  timestamps: false
});

module.exports = Carrito;