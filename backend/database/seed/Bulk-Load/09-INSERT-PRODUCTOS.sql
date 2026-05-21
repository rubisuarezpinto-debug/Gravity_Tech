INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock, sku, id_marca) VALUES 
('PlayStation 5 Slim', 'Consola con lector de discos 1TB', 499.99, 15, 'GA-PS5-SLIM', 1),
('iPhone 15 Pro Max', 'Titanio Natural 256GB', 1199.00, 10, 'AP-IP15PM', 4),
('Zapatillas Air Max 90', 'Clásico diseño urbano', 130.00, 45, 'NK-AM90-W', 2),
('Monitor Samsung Odyssey G9', '49 pulgadas Ultra Wide', 1299.99, 5, 'SA-OD-G9', 3),
('Mouse MX Master 3S', 'Ergonómico para productividad', 99.00, 30, 'LO-MX3S', 6),
('Camiseta Real Madrid 2024', 'Equipación oficial local', 95.00, 100, 'AD-RM24-H', 5),
('Xiaomi 14 Ultra', 'Cámara Leica 512GB', 999.00, 12, 'XI-14U-BK', 7),
('Audífonos Sony WH-1000XM5', 'Cancelación de ruido líder', 349.00, 20, 'SO-XM5-SL', 1),
('Balón Adidas Al Rihla', 'Balón oficial FIFA', 40.00, 60, 'AD-BAL-FIFA', 5),
('Teclado Logitech G915', 'Mecánico inalámbrico RGB', 229.00, 18, 'LO-G915-BR', 6),
('MacBook Air M3', '13 pulgadas, 8GB RAM', 1099.00, 8, 'AP-MBA-M3', 4),
('Samsung Galaxy S24 Ultra', 'Pantalla plana 120Hz', 1299.00, 15, 'SA-S24-ULT', 3),
('Nike Tech Fleece', 'Sudadera con capucha negra', 110.00, 40, 'NK-TF-HD', 2),
('Apple Watch Ultra 2', 'GPS + Celular 49mm', 799.00, 25, 'AP-AW-U2', 4),
('LG C3 OLED TV', '55 pulgadas 4K Smart TV', 1499.00, 7, 'LG-C3-55', 8),
('Cámara Sony A7 IV', 'Mirrorless Full Frame', 2499.00, 4, 'SO-A7IV-B', 1),
('Xiaomi Pad 6', 'Tablet 144Hz 256GB', 399.00, 20, 'XI-PAD6-GR', 7),
('Barra de Sonido Sony A5000', '5.1.2 canales Dolby Atmos', 799.00, 10, 'SO-HT-A5000', 1),
('Zapatillas Nike Dunk Low', 'Panda colorway blanco y negro', 115.00, 50, 'NK-DUNK-PND', 2),
('SSD Samsung 990 Pro 2TB', 'NVMe Gen4 ultra rápido', 180.00, 100, 'SA-990P-2TB', 3);

SELECT setval('ecommerce.producto_id_producto_seq', COALESCE((SELECT MAX(id_producto) FROM ecommerce.producto), 1));