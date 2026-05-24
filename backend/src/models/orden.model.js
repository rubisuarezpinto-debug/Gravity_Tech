const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Orden = sequelize.define('orden', {
  id_orden: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_usuario: { type: DataTypes.INTEGER, allowNull: false },
  id_direccion: { type: DataTypes.INTEGER, allowNull: false },
  id_metodo_pago: { type: DataTypes.INTEGER, allowNull: false },
  id_tipo_envio: { type: DataTypes.INTEGER, allowNull: false },
  id_estado: { type: DataTypes.INTEGER, allowNull: false },
  total: { type: DataTypes.DECIMAL(10, 2), allowNull: false, defaultValue: 0.00 },
  fecha_orden: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'orden',
  timestamps: false
});

module.exports = Orden;