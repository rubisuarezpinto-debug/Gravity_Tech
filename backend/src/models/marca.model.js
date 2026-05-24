const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Marca = sequelize.define('marca', {
  id_marca: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nombre: { type: DataTypes.STRING(100), allowNull: false }
}, {
  schema: 'ecommerce',
  tableName: 'marca',
  timestamps: false
});

module.exports = Marca;