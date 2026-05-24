require('dotenv').config();
require('./config/mailer'); // Ajusta la ruta si es necesario
const app = require('./app');
const { sequelize } = require('./config/database');  // Ajusta según tu ORM

const PORT = process.env.PORT || 3000;

async function startServer() {
  try {
    // ─── Verificar conexión a base de datos ───────────────────────────────────
    await sequelize.authenticate();
    console.log('✅ Conexión a la base de datos exitosa');

    // ─── Sincronizar modelos (solo en desarrollo) ─────────────────────────────
    if (process.env.NODE_ENV === 'development') {
      await sequelize.sync({ alter: true });
      console.log('✅ Modelos sincronizados con la BD');
    }

    // ─── Levantar servidor ────────────────────────────────────────────────────
    app.listen(PORT, () => {
      console.log(`🚀 Gravity Tech API corriendo en http://localhost:${PORT}`);
      console.log(`📋 Health check: http://localhost:${PORT}/health`);
      console.log(`🌍 Entorno: ${process.env.NODE_ENV || 'development'}`);
    });

  } catch (error) {
    console.error('❌ Error al iniciar el servidor:', error);
    process.exit(1);
  }
}

startServer();