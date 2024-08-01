import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../expense_model.dart';

List<PieChartSectionData> getSections(List<ExpenseModel> expenses) {
  final Map<String, double> categoryAmountMap = {};

  for (var expense in expenses) {
    if (!expense.isIncome) {
      if (categoryAmountMap.containsKey(expense.category)) {
        categoryAmountMap[expense.category] =
            categoryAmountMap[expense.category]! + expense.amount;
      } else {
        categoryAmountMap[expense.category] = expense.amount;
      }
    }
  }

  final List<PieChartSectionData> sections = [];
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.teal,
  ];

  categoryAmountMap.forEach((category, amount) {
    final int colorIndex = sections.length % colors.length;
    sections.add(PieChartSectionData(
      color: colors[colorIndex],
      value: amount,
      title: category,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ));
  });

  return sections;
}
