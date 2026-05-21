INSERT INTO ecommerce.categoria (nombre) VALUES 
('Tecnología'), 
('Calzado'), 
('Ropa'), 
('Deportes'), 
('Hogar'), 
('Accesorios'), 
('Libros');

SELECT setval('ecommerce.categoria_id_categoria_seq', COALESCE((SELECT MAX(id_categoria) FROM ecommerce.categoria), 1));