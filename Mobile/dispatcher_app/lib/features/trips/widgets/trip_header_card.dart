import 'package:flutter/material.dart';
import '../../../models/trip.dart';
import 'trip_status_chip.dart';

class TripHeaderCard extends StatelessWidget {
  final Trip trip;

  const TripHeaderCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.local_shipping,
                color: Colors.blue,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    trip.tripNumber,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Dispatch: ${trip.dispatchNumber}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                ],
              ),
            ),

            TripStatusChip(
              status: trip.status,
            ),
          ],
        ),
      ),
    );
  }
}