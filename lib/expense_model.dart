import 'package:flutter/material.dart';

class ExpenseModel {
  final String item;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String category;

  ExpenseModel({
    required this.item,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.category,
  });
}

class ExpenseData extends ChangeNotifier {
  final List<ExpenseModel> _expenses = [];

  List<ExpenseModel> get expenses => _expenses;

  void addExpense(ExpenseModel expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void removeExpense(ExpenseModel expense) {
    _expenses.remove(expense);
    notifyListeners();
  }
}
