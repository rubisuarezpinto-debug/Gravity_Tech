import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Panel de Control General (Admin)', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}