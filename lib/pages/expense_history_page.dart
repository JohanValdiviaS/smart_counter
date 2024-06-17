import 'package:flutter/material.dart';

class ExpenseHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  const ExpenseHistoryScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          var expense = expenses[index];
          return ListTile(
            title: Text('\$${expense['amount']}'),
            subtitle: Text(expense['description']),
          );
        },
      ),
    );
  }
}
