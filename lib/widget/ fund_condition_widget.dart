import 'package:flutter/material.dart';

class FundCondition extends StatelessWidget {
  final String type;
  final String amount;
  final String icon;

  const FundCondition({
    required this.type,
    required this.amount,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          type,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "₹$amount",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
