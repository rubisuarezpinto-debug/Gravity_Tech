INSERT INTO ecommerce.marca (nombre) VALUES 
('Sony'), 
('Nike'), 
('Samsung'), 
('Apple'), 
('Adidas'), 
('Logitech'), 
('Xiaomi'), 
('LG');

SELECT setval('ecommerce.marca_id_marca_seq', COALESCE((SELECT MAX(id_marca) FROM ecommerce.marca), 1));