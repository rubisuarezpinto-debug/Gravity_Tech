-- Primero te conectas a tu base de datos
psql -U postgres -d gravity_tech_rubi

-- Luego ejecutas los archivos maestros (Cátalogo) uno por uno:
\i 'backend/database/seed/Catalogo/01-INSERT-CATEGORIAS.sql'
\i 'backend/database/seed/Catalogo/02-INSERT-MARCAS.sql'
\i 'backend/database/seed/Catalogo/03-INSERT-TIPO-ENVIO.sql'
\i 'backend/database/seed/Catalogo/04-INSERT-ESTADO-ORDEN.sql'
\i 'backend/database/seed/Catalogo/05-INSERT-METODO-PAGO.sql'

-- Después ejecutas el cargue masivo (Bulk-Load):
\i 'backend/database/seed/Bulk-Load/06-INSERT-USUARIOS.sql'
\i 'backend/database/seed/Bulk-Load/07-INSERT-DIRECCIONES.sql'
\i 'backend/database/seed/Bulk-Load/08-INSERT-USUARIO-METODO-PAGO.sql'
\i 'backend/database/seed/Bulk-Load/09-INSERT-PRODUCTOS.sql'
\i 'backend/database/seed/Bulk-Load/10-INSERT-PRODUCTO-CATEGORIA.sql'
\i 'backend/database/seed/Bulk-Load/11-INSERT-IMAGENES.sql'
\i 'backend/database/seed/Bulk-Load/12-INSERT-CARRITOS.sql'
\i 'backend/database/seed/Bulk-Load/13-INSERT-CARRITO-ITEMS.sql'
\i 'backend/database/seed/Bulk-Load/14-INSERT-ORDENES.sql'
\i 'backend/database/seed/Bulk-Load/15-INSERT-ORDEN-ITEMS.sql'
\i 'backend/database/seed/Bulk-Load/16-INSERT-PAGOS.sql'
\i 'backend/database/seed/Bulk-Load/17-INSERT-RESENAS.sql'
\i 'backend/database/seed/Bulk-Load/18-INSERT-AUDITORIA.sql'