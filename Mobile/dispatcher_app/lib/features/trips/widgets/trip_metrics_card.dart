import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripMetricsCard extends StatelessWidget {

  final Trip trip;

  const TripMetricsCard({
    super.key,
    required this.trip,
  });

  Widget metric(
      String title,
      String value,
      IconData icon,
      ) {
    return Expanded(
      child: Column(
        children: [

          Icon(icon,color: Colors.blue),

          const SizedBox(height:8),

          Text(
            value,
            style: const TextStyle(
              fontSize:18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height:4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Row(

          children: [

            metric(
              "Distance",
              "${trip.distanceKm} km",
              Icons.route,
            ),

            metric(
              "Fuel",
              "${trip.fuelUsed} L",
              Icons.local_gas_station,
            ),

            metric(
              "Odometer",
              "${trip.odometer}",
              Icons.speed,
            ),

          ],
        ),
      ),
    );
  }
}