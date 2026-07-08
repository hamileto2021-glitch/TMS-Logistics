import 'package:flutter/material.dart';

class ShipmentStatusCard extends StatelessWidget {
  final int pending;
  final int dispatched;
  final int delivered;

  const ShipmentStatusCard({
    super.key,
    required this.pending,
    required this.dispatched,
    required this.delivered,
  });

  Widget row(
      String title,
      int value,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [

          CircleAvatar(
            radius: 8,
            backgroundColor: color,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(title),
          ),

          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Shipment Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(height: 10),

            row(
              "Pending",
              pending,
              Colors.orange,
            ),

            row(
              "Dispatched",
              dispatched,
              Colors.blue,
            ),

            row(
              "Delivered",
              delivered,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}