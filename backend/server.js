require('dotenv').config();
const app = require('./app');

const PORT = process.env.PORT || 3000;

// Agregamos '0.0.0.0' para abrir los puertos a tu celular en la red local
app.listen(PORT, '0.0.0.0', () => {
  console.log(`TechStore server running on port ${PORT}`);
});