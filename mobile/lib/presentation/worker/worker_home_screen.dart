import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'worker_product_form_screen.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        title: const Text("Panel de Empleado"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMenuButton(
              context,
              "Gestionar Inventario",
              Icons.inventory,
              Colors.blueAccent,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen())),
            ),
            const SizedBox(height: 15),
            _buildMenuButton(
              context,
              "Registrar Nuevo Producto",
              Icons.add_box,
              Colors.greenAccent,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerProductFormScreen())),
            ),
            const Spacer(),
            Text("Gravity Tech - Sistema Interno", style: TextStyle(color: Colors.white.withOpacity(0.3))),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}