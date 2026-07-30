import 'package:flutter/material.dart';

import '../models/active_trip.dart';
import 'status_badge.dart';

class TripHeader extends StatelessWidget {
  final ActiveTrip trip;

  const TripHeader({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              trip.tripNumber,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              trip.shipmentNumber,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 16),

            StatusBadge(
              status: trip.status,
            ),
          ],
        ),
      ),
    );
  }
}