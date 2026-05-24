const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const EstadoOrden = sequelize.define('estado_orden', {
  id_estado: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nombre: { type: DataTypes.STRING(100), allowNull: false }
}, {
  schema: 'ecommerce',
  tableName: 'estado_orden',
  timestamps: false
});

module.exports = EstadoOrden;