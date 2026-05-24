const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Cupon = sequelize.define('cupon', {
  id_cupon: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  codigo: { type: DataTypes.STRING(50), allowNull: false },
  porcentaje_descuento: { type: DataTypes.DECIMAL(5, 2), allowNull: false },
  activo: { type: DataTypes.BOOLEAN, defaultValue: true },
  fecha_expiracion: { type: DataTypes.DATEONLY }
}, {
  schema: 'ecommerce',
  tableName: 'cupon',
  timestamps: false
});

module.exports = Cupon;