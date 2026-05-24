const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Auditoria = sequelize.define('auditoria', {
  id_auditoria: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_usuario: { type: DataTypes.INTEGER, allowNull: false },
  accion: { type: DataTypes.STRING(100), allowNull: false },
  entidad: { type: DataTypes.STRING(100), allowNull: false },
  timestamp: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  detalle: { type: DataTypes.TEXT }
}, {
  schema: 'ecommerce',
  tableName: 'auditoria',
  timestamps: false
});

module.exports = Auditoria;