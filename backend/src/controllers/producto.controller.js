const Producto = require('../models/producto.model');
const Imagen = require('../models/imagen.model');
const ProductoCategoria = require('../models/productoCategoria.model');

const normalizeProduct = async (producto) => {
  const data = producto.toJSON();
  const idProducto = data.id_producto;
  const primaryImage = await Imagen.findOne({ where: { id_producto: idProducto, es_principal: true } });
  const categoria = await ProductoCategoria.findOne({ where: { id_producto: idProducto } });

  return {
    id: data.id_producto,
    name: data.nombre,
    description: data.descripcion,
    price: Number(data.precio),
    stock: data.stock,
    sku: data.sku,
    brand_id: data.id_marca,
    id_marca: data.id_marca,
    category_id: categoria?.id_categoria || null,
    id_categoria: categoria?.id_categoria || null,
    estado: data.estado,
    image_url: primaryImage?.url || null,
    created_at: data.fecha_creacion,
    updated_at: data.fecha_actualizacion
  };
};

const getAll = async (req, res, next) => {
  try {
    const products = await Producto.findAll();
    const result = await Promise.all(products.map(normalizeProduct));
    res.json({ products: result });
  } catch (error) {
    next(error);
  }
};

const getById = async (req, res, next) => {
  try {
    const producto = await Producto.findByPk(req.params.id);
    if (!producto) return res.status(404).json({ message: 'Producto no encontrado' });
    const result = await normalizeProduct(producto);
    res.json({ product: result });
  } catch (error) {
    next(error);
  }
};

const create = async (req, res, next) => {
  try {
    const {
      name,
      description,
      price,
      stock,
      brand_id,
      id_marca,
      category_id,
      image_url,
      sku
    } = req.body;

    const producto = await Producto.create({
      nombre: name,
      descripcion: description,
      precio: price,
      stock,
      sku,
      id_marca: brand_id || id_marca,
      fecha_creacion: new Date(),
      fecha_actualizacion: new Date()
    });

    if (category_id) {
      await ProductoCategoria.create({ id_producto: producto.id_producto, id_categoria: category_id });
    }

    if (image_url) {
      await Imagen.create({ id_producto: producto.id_producto, url: image_url, es_principal: true });
    }

    const response = await normalizeProduct(producto);
    res.status(201).json({ message: 'Producto creado', product: response });
  } catch (error) {
    next(error);
  }
};

const update = async (req, res, next) => {
  try {
    const producto = await Producto.findByPk(req.params.id);
    if (!producto) return res.status(404).json({ message: 'Producto no encontrado' });

    const {
      name,
      description,
      price,
      stock,
      brand_id,
      id_marca,
      category_id,
      sku
    } = req.body;

    await producto.update({
      nombre: name ?? producto.nombre,
      descripcion: description ?? producto.descripcion,
      precio: price ?? producto.precio,
      stock: stock ?? producto.stock,
      sku: sku ?? producto.sku,
      id_marca: brand_id ?? id_marca ?? producto.id_marca,
      fecha_actualizacion: new Date()
    });

    if (category_id !== undefined) {
      await ProductoCategoria.destroy({ where: { id_producto: producto.id_producto } });
      if (category_id) {
        await ProductoCategoria.create({ id_producto: producto.id_producto, id_categoria: category_id });
      }
    }

    const response = await normalizeProduct(producto);
    res.json({ message: 'Producto actualizado', product: response });
  } catch (error) {
    next(error);
  }
};

const remove = async (req, res, next) => {
  try {
    const producto = await Producto.findByPk(req.params.id);
    if (!producto) return res.status(404).json({ message: 'Producto no encontrado' });

    await ProductoCategoria.destroy({ where: { id_producto: producto.id_producto } });
    await Imagen.destroy({ where: { id_producto: producto.id_producto } });
    await producto.destroy();

    res.json({ message: 'Producto eliminado' });
  } catch (error) {
    next(error);
  }
};

const updateImage = async (req, res, next) => {
  try {
    const { image_url } = req.body;
    if (!image_url) return res.status(400).json({ message: 'La URL de imagen es obligatoria' });

    const producto = await Producto.findByPk(req.params.id);
    if (!producto) return res.status(404).json({ message: 'Producto no encontrado' });

    let imagen = await Imagen.findOne({ where: { id_producto: producto.id_producto, es_principal: true } });
    if (imagen) {
      await imagen.update({ url: image_url });
    } else {
      await Imagen.create({ id_producto: producto.id_producto, url: image_url, es_principal: true });
    }

    res.json({ message: 'Imagen de producto actualizada' });
  } catch (error) {
    next(error);
  }
};

const getLowStock = async (req, res, next) => {
  try {
    res.json({ products: [] }); // Placeholder temporal
  } catch (error) {
    next(error);
  }
};

const restock = async (req, res, next) => {
  try {
    res.json({ message: 'Restock completado' }); // Placeholder temporal
  } catch (error) {
    next(error);
  }
};

module.exports = { 
  getAll, 
  getById, 
  create, 
  update, 
  remove, 
  updateImage, 
  getLowStock, 
  restock 
};