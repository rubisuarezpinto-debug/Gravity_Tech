import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/product_service.dart';
import '../widgets/worker_bottom_nav.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final products = await ProductService.getProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.rose),
    );
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF4c2f9e)),
    );
  }

  Future<void> _openCreateDialog() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateProductSheet(),
    );
    if (result == true) {
      _showSuccess('Producto creado correctamente');
      _loadProducts();
    }
  }

  Future<void> _openDeleteDialog() async {
    if (_products.isEmpty) {
      _showError('No hay productos para eliminar');
      return;
    }
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteProductSheet(products: _products),
    );
    if (result == true) {
      _showSuccess('Producto eliminado correctamente');
      _loadProducts();
    }
  }

  Future<void> _openRestockDialog() async {
    if (_products.isEmpty) {
      _showError('No hay productos disponibles');
      return;
    }
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RestockProductSheet(products: _products),
    );
    if (result == true) {
      _showSuccess('Stock actualizado correctamente');
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 16, color: AppColors.lavender),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text('Gestión de Productos',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                          ),
                        ),
                        GestureDetector(
                          onTap: _loadProducts,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.lavender),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _loading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text('Cargando productos...',
                                style: TextStyle(fontSize: 12, color: AppColors.lavender)),
                          )
                        : Text('${_products.length} productos disponibles',
                            style: const TextStyle(fontSize: 12, color: AppColors.lavender)),
                    const SizedBox(height: 20),
                    _ActionBtn(
                      label: 'Crear producto',
                      icon: Icons.add_circle_outline_rounded,
                      bgColor: const Color(0x664c2f9e),
                      textColor: AppColors.lavender,
                      borderColor: AppColors.violet,
                      onTap: _openCreateDialog,
                    ),
                    const SizedBox(height: 10),
                    _ActionBtn(
                      label: 'Eliminar producto',
                      icon: Icons.delete_outline_rounded,
                      bgColor: const Color(0x26d4537e),
                      textColor: AppColors.rose,
                      borderColor: const Color(0x66d4537e),
                      onTap: _openDeleteDialog,
                    ),
                    const SizedBox(height: 10),
                    _ActionBtn(
                      label: 'Actualizar / Reabastecer',
                      icon: Icons.refresh_rounded,
                      bgColor: const Color(0x332979d4),
                      textColor: AppColors.sky,
                      borderColor: const Color(0x662979d4),
                      onTap: _openRestockDialog,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0x33d4537e),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0x66d4537e)),
                        ),
                        child: Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.rose)),
                      ),
                    ],
                    const Divider(color: AppColors.border, height: 32),
                    const Text('Productos con stock bajo',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    if (_loading)
                      const Center(child: CircularProgressIndicator(color: AppColors.violet))
                    else if (_products.isEmpty)
                      const Text('Sin productos', style: TextStyle(fontSize: 12, color: AppColors.gray))
                    else
                      ..._products
                          .where((p) => (int.tryParse(p['stock']?.toString() ?? '') ?? 0) < 5)
                          .take(5)
                          .map((p) => _ProductRow(product: p)),
                  ],
                ),
              ),
            ),
            WorkerBottomNav(currentIndex: 1, onTap: (i) {
              if (i == 0) context.go('/worker/home');
              if (i == 2) context.go('/worker/profile');
            }),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? '';
    final stock = int.tryParse(product['stock']?.toString() ?? '') ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text('• $name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.gray)),
          ),
          Text('$stock uds', style: const TextStyle(fontSize: 12, color: AppColors.rose)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
          ],
        ),
      ),
    );
  }
}

// ─── Create Product Sheet ────────────────────────────────────────────────────

class _CreateProductSheet extends StatefulWidget {
  const _CreateProductSheet();

  @override
  State<_CreateProductSheet> createState() => _CreateProductSheetState();
}

class _CreateProductSheetState extends State<_CreateProductSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_nameCtrl.text.trim().length < 3) return 'El nombre debe tener al menos 3 caracteres';
    if (_descCtrl.text.trim().length < 10) return 'La descripción debe tener al menos 10 caracteres';
    final price = double.tryParse(_priceCtrl.text);
    if (price == null || price <= 0) return 'Ingresa un precio válido mayor a 0';
    final stock = int.tryParse(_stockCtrl.text);
    if (stock == null || stock < 0) return 'Ingresa un stock válido (0 o más)';
    return null;
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ProductService.createProduct(
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        price: double.parse(_priceCtrl.text),
        stock: int.parse(_stockCtrl.text),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BottomSheet(
      title: 'Crear producto',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetInput(label: 'Nombre del producto', controller: _nameCtrl),
          const SizedBox(height: 12),
          _SheetInput(label: 'Descripción', controller: _descCtrl, maxLines: 3),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SheetInput(
                  label: 'Precio (\$)',
                  controller: _priceCtrl,
                  inputType: const TextInputType.numberWithOptions(decimal: true),
                  formatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SheetInput(
                  label: 'Stock',
                  controller: _stockCtrl,
                  inputType: TextInputType.number,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.rose)),
          ],
          const SizedBox(height: 20),
          _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.violet))
              : GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Crear producto',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.white)),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Delete Product Sheet ────────────────────────────────────────────────────

class _DeleteProductSheet extends StatefulWidget {
  const _DeleteProductSheet({required this.products});
  final List<Map<String, dynamic>> products;

  @override
  State<_DeleteProductSheet> createState() => _DeleteProductSheetState();
}

class _DeleteProductSheetState extends State<_DeleteProductSheet> {
  int? _selectedId;
  bool _loading = false;

  Future<void> _delete() async {
    if (_selectedId == null) return;
    setState(() => _loading = true);
    try {
      await ProductService.deleteProduct(_selectedId!);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: AppColors.rose),
      );
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BottomSheet(
      title: 'Eliminar producto',
      child: Column(
        children: [
          ...widget.products.map((p) {
            final id = p['id'] is int ? p['id'] as int : int.parse(p['id'].toString());
            final name = p['name'] as String? ?? '';
            final selected = _selectedId == id;
            return GestureDetector(
              onTap: () => setState(() => _selectedId = id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0x33d4537e) : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected ? AppColors.rose : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: selected ? AppColors.rose : AppColors.lavender,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              color: selected ? AppColors.rose : AppColors.white)),
                    ),
                    Text('stock: ${p['stock']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.gray)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (_selectedId != null)
            _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.rose))
                : GestureDetector(
                    onTap: _delete,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0x66d4537e),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.rose),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Eliminar producto seleccionado',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.rose)),
                    ),
                  ),
        ],
      ),
    );
  }
}

// ─── Restock Product Sheet ───────────────────────────────────────────────────

class _RestockProductSheet extends StatefulWidget {
  const _RestockProductSheet({required this.products});
  final List<Map<String, dynamic>> products;

  @override
  State<_RestockProductSheet> createState() => _RestockProductSheetState();
}

class _RestockProductSheetState extends State<_RestockProductSheet> {
  Map<String, dynamic>? _selected;
  final _stockCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (_selected == null) return;
    final stock = int.tryParse(_stockCtrl.text);
    if (stock == null || stock < 0) {
      setState(() => _error = 'Ingresa un stock válido');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final productId = _selected!['id'] is int ? _selected!['id'] as int : int.parse(_selected!['id'].toString());
      final existingName  = _selected!['name']        as String?;
      final existingDesc  = _selected!['description'] as String?;
      final existingPrice = _selected!['price'] is num ? (_selected!['price'] as num).toDouble() : double.tryParse(_selected!['price']?.toString() ?? '');
      await ProductService.updateStock(
        productId,
        stock,
        name: existingName,
        description: existingDesc,
        price: existingPrice,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BottomSheet(
      title: 'Actualizar stock',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecciona un producto:',
              style: TextStyle(fontSize: 12, color: AppColors.lavender)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Map<String, dynamic>>(
                value: _selected,
                hint: const Text('Seleccionar producto',
                    style: TextStyle(color: AppColors.gray, fontSize: 13)),
                dropdownColor: AppColors.surface,
                isExpanded: true,
                items: widget.products
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            '${p['name']} (stock: ${p['stock']})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.white, fontSize: 13),
                          ),
                        ))
                    .toList(),
                onChanged: (p) {
                  setState(() {
                    _selected = p;
                    _stockCtrl.text = p?['stock']?.toString() ?? '';
                  });
                },
              ),
            ),
          ),
          if (_selected != null) ...[
            const SizedBox(height: 12),
            _SheetInput(
              label: 'Nuevo stock',
              controller: _stockCtrl,
              inputType: TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.rose)),
          ],
          const SizedBox(height: 20),
          if (_selected != null)
            _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.violet))
                : GestureDetector(
                    onTap: _update,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0x332979d4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x662979d4)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Actualizar stock',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.sky)),
                    ),
                  ),
        ],
      ),
    );
  }
}

// ─── Shared Sheet Widgets ────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded, color: AppColors.lavender, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.inputType,
    this.formatters,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.lavender)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: inputType,
            inputFormatters: formatters,
            style: const TextStyle(fontSize: 13, color: AppColors.white),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
      ],
    );
  }
}
