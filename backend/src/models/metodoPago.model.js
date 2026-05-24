const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const MetodoPago = sequelize.define('metodo_pago', {
  id_metodo_pago: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nombre: { type: DataTypes.STRING(100), allowNull: false }
}, {
  schema: 'ecommerce',
  tableName: 'metodo_pago',
  timestamps: false
});

module.exports = MetodoPago;