import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'trip_status_chip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  const Icon(
                    Icons.local_shipping,
                    color: Colors.blue,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      trip.tripNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  TripStatusChip(
                    status: trip.status,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildRow(
                Icons.inventory_2,
                "Shipment",
                trip.shipmentNumber,
              ),

              _buildRow(
                Icons.directions_car,
                "Vehicle",
                trip.vehiclePlateNumber,
              ),

              _buildRow(
                Icons.person,
                "Driver",
                trip.driverName,
              ),

              const Divider(),

              Row(
                children: [

                  Expanded(
                    child: _buildInfo(
                      "Distance",
                      "${trip.distanceKm} km",
                    ),
                  ),

                  Expanded(
                    child: _buildInfo(
                      "Fuel",
                      "${trip.fuelUsed} L",
                    ),
                  ),

                ],
              ),

              if (trip.startTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Started: ${trip.startTime}",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [

          Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),

          const SizedBox(width: 8),

          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(value),
          ),

        ],
      ),
    );
  }

  Widget _buildInfo(
      String title,
      String value,
      ) {
    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

      ],
    );
  }
}