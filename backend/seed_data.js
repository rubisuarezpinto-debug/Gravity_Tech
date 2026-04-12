const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DB_URL,
});

async function seed() {
  try {
    console.log('Inserting sample data...');

    // 1. Categorías
    await pool.query("INSERT INTO ecommerce.categoria (nombre) VALUES ('Computadores'), ('Celulares'), ('Accesorios'), ('Videojuegos') ON CONFLICT DO NOTHING");
    
    // 2. Marca
    await pool.query("INSERT INTO ecommerce.marca (nombre) VALUES ('Generica') ON CONFLICT DO NOTHING");

    // 3. Estados de orden
    await pool.query("INSERT INTO ecommerce.estado_orden (nombre) VALUES ('PENDIENTE'), ('PAGADO'), ('ENVIADO'), ('ENTREGADO'), ('CANCELADO') ON CONFLICT DO NOTHING");

    // 4. Usuarios (Password: Password123!)
    // Hash para 'Password123!' (usando el formato de bcrypt que suelen tener estos proyectos si usaron bcryptjs)
    const passHash = '$2a$10$X87S10f7A.cZtM8kG8M8.u9xS1G0G0G0G0G0G0G0G0G0G0G0G0G0G'; // Placeholder hash
    await pool.query(`INSERT INTO ecommerce.usuario (nombre, email, password_hash, rol) VALUES 
      ('Admin Store', 'admin@tech.com', '${passHash}', 'admin'),
      ('Juan Perez', 'juan@email.com', '${passHash}', 'cliente')
      ON CONFLICT DO NOTHING`);

    // 5. Productos
    const prod1 = await pool.query(`INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock, id_marca) 
      VALUES ('Laptop Pro 15', 'Potente laptop para trabajo pesado', 4500000, 10, 1) RETURNING id_producto`);
    const prod2 = await pool.query(`INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock, id_marca) 
      VALUES ('Smartphone X', 'La mejor cámara del mercado', 2800000, 15, 1) RETURNING id_producto`);
    
    // 6. Imágenes
    if (prod1.rows[0]) {
      await pool.query("INSERT INTO ecommerce.imagen (id_producto, url) VALUES ($1, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=300&h=200')", [prod1.rows[0].id_producto]);
    }
    if (prod2.rows[0]) {
      await pool.query("INSERT INTO ecommerce.imagen (id_producto, url) VALUES ($1, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=300&h=200')", [prod2.rows[0].id_producto]);
    }

    console.log('Sample data inserted successfully!');
  } catch (err) {
    console.error('Error seeding data:', err);
  } finally {
    await pool.end();
  }
}

seed();
