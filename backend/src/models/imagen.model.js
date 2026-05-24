const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Imagen = sequelize.define('imagen', {
  id_imagen: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_producto: { type: DataTypes.INTEGER, allowNull: false },
  url: { type: DataTypes.STRING(500), allowNull: false },
  es_principal: { type: DataTypes.BOOLEAN, defaultValue: false },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'imagen',
  timestamps: false
});

module.exports = Imagen;