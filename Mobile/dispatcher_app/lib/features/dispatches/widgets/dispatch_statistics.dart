import 'package:flutter/material.dart';

import '../models/dispatch.dart';

class DispatchStatistics extends StatelessWidget {
  final List<Dispatch> dispatches;

  const DispatchStatistics({
    super.key,
    required this.dispatches,
  });

  @override
  Widget build(BuildContext context) {
    final total = dispatches.length;

    final scheduled = dispatches
        .where((d) => d.status == "Scheduled")
        .length;

    final progress = dispatches
        .where((d) => d.status == "In Progress")
        .length;

    final completed = dispatches
        .where((d) => d.status == "Completed")
        .length;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

          Expanded(
            child: _card(
              "Total",
              total.toString(),
              Colors.blue,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _card(
              "Scheduled",
              scheduled.toString(),
              Colors.orange,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _card(
              "Completed",
              completed.toString(),
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(
      String title,
      String value,
      Color color,
      ) {
    return Card(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}