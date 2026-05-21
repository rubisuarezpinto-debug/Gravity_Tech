INSERT INTO ecommerce.carrito (id_usuario) VALUES 
(2), 
(3), 
(4);

SELECT setval('ecommerce.carrito_id_carrito_seq', COALESCE((SELECT MAX(id_carrito) FROM ecommerce.carrito), 1));