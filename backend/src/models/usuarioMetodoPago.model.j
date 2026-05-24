const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const UsuarioMetodoPago = sequelize.define('usuario_metodo_pago', {
  id_usuario: { type: DataTypes.INTEGER, primaryKey: true },
  id_metodo_pago: { type: DataTypes.INTEGER, primaryKey: true },
  estado: { type: DataTypes.STRING(20), defaultValue: 'ACTIVO' },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'usuario_metodo_pago',
  timestamps: false
});

module.exports = UsuarioMetodoPago;