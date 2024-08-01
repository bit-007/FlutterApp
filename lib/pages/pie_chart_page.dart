import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../expense_model.dart';
import '../widget/pie_chart_sections.dart';

class PieChartPage extends StatelessWidget {
  const PieChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Distribution"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Consumer<ExpenseData>(
                  builder: (context, expenseData, child) {
                    return PieChart(
                      PieChartData(
                        sections: getSections(expenseData.expenses
                            .where((expense) => !expense.isIncome)
                            .toList()),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Consumer<ExpenseData>(
                builder: (context, expenseData, child) {
                  final expenseCategories = expenseData.expenses
                      .where((expense) => !expense.isIncome)
                      .map((expense) => expense.category)
                      .toSet()
                      .toList();
                  return ListView.builder(
                    itemCount: expenseCategories.length,
                    itemBuilder: (context, index) {
                      final category = expenseCategories[index];
                      final totalAmount = expenseData.expenses
                          .where((expense) =>
                      !expense.isIncome &&
                          expense.category == category)
                          .fold(0.0, (sum, expense) => sum + expense.amount);
                      final color = getSections(expenseData.expenses)
                          .firstWhere((section) => section.title == category)
                          .color;
                      return ListTile(
                        leading: Container(
                          width: 16,
                          height: 16,
                          color: color,
                        ),
                        title: Text(category),
                        trailing: Text("₹${totalAmount.toStringAsFixed(2)}"),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
