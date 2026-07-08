import 'package:flutter/material.dart';

import '../models/trip.dart';

class TripStatistics extends StatelessWidget {
  final List<Trip> trips;

  const TripStatistics({
    super.key,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    final total = trips.length;

    final active = trips
        .where((t) => t.status == "In Progress")
        .length;

    final completed = trips
        .where((t) => t.status == "Completed")
        .length;

    final scheduled = trips
        .where((t) => t.status == "Scheduled")
        .length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [

          Expanded(
            child: _card(
              "Total",
              total.toString(),
              Colors.blue,
              Icons.route,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _card(
              "Active",
              active.toString(),
              Colors.orange,
              Icons.local_shipping,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _card(
              "Completed",
              completed.toString(),
              Colors.green,
              Icons.check_circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _card(
              "Scheduled",
              scheduled.toString(),
              Colors.purple,
              Icons.schedule,
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
      IconData icon,
      ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        child: Column(
          children: [

            Icon(
              icon,
              color: color,
              size: 30,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}