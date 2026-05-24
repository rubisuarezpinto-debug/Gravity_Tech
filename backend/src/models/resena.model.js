const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Resena = sequelize.define('resena', {
  id_resena: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  id_usuario: { type: DataTypes.INTEGER, allowNull: false },
  id_producto: { type: DataTypes.INTEGER, allowNull: false },
  comentario: { type: DataTypes.TEXT },
  puntuacion: {
    type: DataTypes.INTEGER,
    validate: { min: 1, max: 5 }
  },
  fecha_creacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  schema: 'ecommerce',
  tableName: 'resena',
  timestamps: false
});

module.exports = Resena;