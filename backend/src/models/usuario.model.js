const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Usuario = sequelize.define('usuario', {
  id_usuario: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nombre: { type: DataTypes.STRING(150) },
  email: { type: DataTypes.STRING(150), allowNull: false, unique: true },
  password_hash: { type: DataTypes.STRING(255), allowNull: false },
  rol: { type: DataTypes.STRING(20), defaultValue: 'cliente' },
  estado: { type: DataTypes.STRING(20), defaultValue: 'ACTIVO' },
  telefono: { type: DataTypes.STRING(20) },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  fecha_actualizacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  sms_code: { type: DataTypes.STRING(6) },
  sms_expires_at: { type: DataTypes.DATE }
}, {
  schema: 'ecommerce',
  tableName: 'usuario',
  timestamps: false
});

module.exports = Usuario;