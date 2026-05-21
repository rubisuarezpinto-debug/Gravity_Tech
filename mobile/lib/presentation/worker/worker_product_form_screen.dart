import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import '../../logic/blocs/product/product_bloc.dart';
import '../../logic/blocs/product/product_event.dart';

class WorkerProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const WorkerProductFormScreen({super.key, this.product});

  @override
  State<WorkerProductFormScreen> createState() => _WorkerProductFormScreenState();
}

class _WorkerProductFormScreenState extends State<WorkerProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Usamos los nombres exactos definidos en tu ProductModel
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        title: Text(widget.product == null ? "Nuevo Producto" : "Editar Producto"),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, "Nombre", Icons.shopping_basket),
              _buildTextField(_descController, "Descripción", Icons.description, maxLines: 3),
              Row(
                children: [
                  Expanded(child: _buildTextField(_priceController, "Precio", Icons.attach_money, isNumber: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(_stockController, "Stock", Icons.inventory, isNumber: true)),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: _submit,
                  child: const Text("GUARDAR", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Creamos la instancia usando el constructor de ProductModel
      final product = ProductModel(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        description: _descController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text) ?? 0,
        idMarca: widget.product?.idMarca ?? 1, // Valor por defecto
      );

      // Enviamos el evento sin nombre de parámetro para coincidir con tu clase Event
      if (widget.product == null) {
        context.read<ProductBloc>().add(CreateProductEvent(product));
      } else {
        context.read<ProductBloc>().add(UpdateProductEvent(product));
      }
      Navigator.pop(context);
    }
  }
}