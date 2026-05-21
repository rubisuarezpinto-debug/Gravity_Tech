INSERT INTO ecommerce.direccion (id_usuario, direccion, ciudad, pais) VALUES 
(2, 'Calle 100 #15-20', 'Bogotá', 'Colombia'),
(3, 'Carrera 80 #45-10', 'Medellín', 'Colombia'),
(4, 'Av. Paseo de la Reforma 222', 'CDMX', 'México'),
(5, 'Calle Florida 500', 'Buenos Aires', 'Argentina'),
(6, 'Av. Larco 123', 'Lima', 'Perú');

SELECT setval('ecommerce.direccion_id_direccion_seq', COALESCE((SELECT MAX(id_direccion) FROM ecommerce.direccion), 1));