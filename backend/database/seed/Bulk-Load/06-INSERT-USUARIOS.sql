INSERT INTO ecommerce.usuario (nombre, email, password_hash, rol, estado, telefono) VALUES 
('Rubi Suarez', 'rubi@gravitytech.com', 'admin_secure_2026', 'admin', 'ACTIVO', '+573001234567'),
('Juan Perez', 'juan.perez@gmail.com', 'user_hash_101', 'cliente', 'ACTIVO', '+573101112222'),
('Maria Casas', 'maria.casas@outlook.com', 'user_hash_102', 'cliente', 'ACTIVO', '+573203334444'),
('Roberto Guia', 'roberto.guia@yahoo.com', 'user_hash_103', 'cliente', 'ACTIVO', '+573155556666'),
('Elena Vargas', 'elena.vargas@mail.com', 'user_hash_104', 'cliente', 'ACTIVO', '+573127778888'),
('Soporte Tecnico', 'soporte@tienda.com', 'user_hash_105', 'empleado', 'ACTIVO', '+573009990000');

SELECT setval('ecommerce.usuario_id_usuario_seq', COALESCE((SELECT MAX(id_usuario) FROM ecommerce.usuario), 1));