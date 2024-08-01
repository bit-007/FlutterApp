import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../expense_model.dart';
import '../pages/pie_chart_page.dart';
import '../widget/ fund_condition_widget.dart';

import '../widget/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final itemController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? pickedDate;
  String currentOption = "expense";

  void _showAddDialog(bool isIncome) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(left: 1.6),
            child: Text(isIncome ? "ADD INCOME" : "ADD EXPENSE"),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    hintText: "Enter the Item",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter the Amount",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                if (!isIncome) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      hintText: "Enter the Category",
                      hintStyle: TextStyle(
                        color: Colors.blueGrey,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    onTap: () async {
                      pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String date = DateFormat.yMMMMd().format(pickedDate!);
                        dateController.text = date;
                        setState(() {});
                      }
                    },
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "DATE",
                      hintStyle: TextStyle(
                        color: Colors.blueGrey,
                      ),
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      prefixIconColor: Colors.blue,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (amountController.text.isNotEmpty &&
                    itemController.text.isNotEmpty &&
                    dateController.text.isNotEmpty) {
                  final amount = double.tryParse(amountController.text) ?? 0.0;
                  final expense = ExpenseModel(
                    item: itemController.text,
                    amount: amount,
                    isIncome: isIncome,
                    date: pickedDate!,
                    category: isIncome ? '' : categoryController.text, // Adjusted here
                  );
                  Provider.of<ExpenseData>(context, listen: false)
                      .addExpense(expense);

                  itemController.clear();
                  amountController.clear();
                  dateController.clear();
                  categoryController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "ADD",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = Provider.of<ExpenseData>(context).expenses
        .where((e) => e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    double totalExpense = Provider.of<ExpenseData>(context).expenses
        .where((e) => !e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    double balance = totalIncome - totalExpense;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () => _showAddDialog(true),
            label: const Text('Add Income'),
            icon: const Icon(Icons.add),
            heroTag: "addIncome",
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () => _showAddDialog(false),
            label: const Text('Add Expense'),
            icon: const Icon(Icons.remove),
            heroTag: "addExpense",
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FundCondition(
                    type: "BALANCE",
                    amount: "$balance",
                    icon: "blue",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FundCondition(
                    type: "EXPENSE",
                    amount: "$totalExpense",
                    icon: "orange",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 8),
                  child: FundCondition(
                    type: "INCOME",
                    amount: "$totalIncome",
                    icon: "grey",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: Provider.of<ExpenseData>(context).expenses.length,
                itemBuilder: (context, index) {
                  final expense =
                  Provider.of<ExpenseData>(context).expenses[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Confirm to Delete the Item?",
                              style: TextStyle(
                                fontSize: 19.0,
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to delete this ${expense.isIncome ? 'income' : 'expense'} item?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<ExpenseData>(context, listen: false)
                                      .removeExpense(expense);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "DELETE",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Item(
                      expense: expense,
                      onDelete: () {
                        Provider.of<ExpenseData>(context, listen: false)
                            .removeExpense(expense);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: const Icon(Icons.pie_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PieChartPage()),
            );
          },
        ),
      ),
    );
  }
}
