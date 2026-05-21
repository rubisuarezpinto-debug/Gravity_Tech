INSERT INTO ecommerce.carrito_item (id_carrito, id_producto, cantidad, precio_unitario) VALUES 
(1, 1, 1, 499.99), 
(1, 5, 2, 99.00), 
(2, 2, 1, 1199.00);

SELECT setval('ecommerce.carrito_item_id_carrito_item_seq', COALESCE((SELECT MAX(id_carrito_item) FROM ecommerce.carrito_item), 1));