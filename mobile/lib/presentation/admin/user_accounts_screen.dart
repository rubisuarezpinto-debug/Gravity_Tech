import 'package:flutter/material.dart';

class AdminUserAccountsScreen extends StatelessWidget {
  const AdminUserAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Auditoría PostgreSQL')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text('Usuario del Sistema $index'),
              subtitle: const Text('operaciones@gravity.com'),
              trailing: Chip(
                label: Text(index == 0 ? 'admin' : 'worker', style: TextStyle(color: theme.colorScheme.primary)),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          );
        },
      ),
    );
  }
}