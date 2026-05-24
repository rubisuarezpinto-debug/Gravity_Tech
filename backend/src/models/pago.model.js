const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Pago = sequelize.define('pago', {
  id_pago: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_orden: { type: DataTypes.INTEGER, allowNull: false },
  monto: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
  referencia: { type: DataTypes.STRING(150) },
  estado: { type: DataTypes.STRING(50), allowNull: false },
  fecha: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'pago',
  timestamps: false
});

module.exports = Pago;