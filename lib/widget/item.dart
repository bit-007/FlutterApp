import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../expense_model.dart';

class Item extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;

  const Item({Key? key, required this.expense, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(expense.item),
        subtitle: Text('Amount: ${expense.amount} - Date: ${DateFormat.yMMMMd().format(expense.date)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
