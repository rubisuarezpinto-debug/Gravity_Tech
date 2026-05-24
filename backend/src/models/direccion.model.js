const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Direccion = sequelize.define('direccion', {
  id_direccion: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_usuario: { type: DataTypes.INTEGER, allowNull: false },
  direccion: { type: DataTypes.STRING(255), allowNull: false },
  ciudad: { type: DataTypes.STRING(100), allowNull: false },
  pais: { type: DataTypes.STRING(100), allowNull: false },
  latitud: { type: DataTypes.DECIMAL(10, 8) },
  longitud: { type: DataTypes.DECIMAL(11, 8) },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'direccion',
  timestamps: false
});

module.exports = Direccion;