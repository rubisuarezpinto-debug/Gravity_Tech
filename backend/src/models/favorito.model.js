const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Favorito = sequelize.define('favorito', {
  id_favorito: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_usuario: { type: DataTypes.INTEGER, allowNull: false },
  id_producto: { type: DataTypes.INTEGER, allowNull: false },
  fecha_agregado: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'favorito',
  timestamps: false
});

module.exports = Favorito;