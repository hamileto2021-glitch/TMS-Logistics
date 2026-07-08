import 'package:flutter/material.dart';

class FleetStatusCard extends StatelessWidget {
  final int available;
  final int assigned;
  final int maintenance;

  const FleetStatusCard({
    super.key,
    required this.available,
    required this.assigned,
    required this.maintenance,
  });

  Widget _item(
      String title,
      int value,
      Color color,
      IconData icon,
      ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
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
                "Fleet Status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            _item(
              "Available",
              available,
              Colors.green,
              Icons.check_circle,
            ),

            _item(
              "Assigned",
              assigned,
              Colors.orange,
              Icons.assignment,
            ),

            _item(
              "Maintenance",
              maintenance,
              Colors.red,
              Icons.build,
            ),
          ],
        ),
      ),
    );
  }
}