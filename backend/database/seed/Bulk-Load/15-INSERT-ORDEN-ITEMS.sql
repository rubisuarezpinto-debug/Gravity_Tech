INSERT INTO ecommerce.orden_item (id_orden, id_producto, cantidad, precio_unitario) VALUES 
(1, 1, 1, 499.99), 
(2, 2, 1, 1199.00);

SELECT setval('ecommerce.orden_item_id_orden_item_seq', COALESCE((SELECT MAX(id_orden_item) FROM ecommerce.orden_item), 1));