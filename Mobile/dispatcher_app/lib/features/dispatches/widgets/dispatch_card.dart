import 'package:flutter/material.dart';

import '../models/dispatch.dart';

class DispatchCard extends StatelessWidget {
  final Dispatch dispatch;
  final VoidCallback onTap;

  const DispatchCard({
    super.key,
    required this.dispatch,
    required this.onTap,
  });

  Color _statusColor() {
    switch (dispatch.status.toLowerCase()) {
      case 'scheduled':
        return Colors.orange;

      case 'in progress':
        return Colors.blue;

      case 'completed':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dispatch.dispatchNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      dispatch.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                "Shipment : ${dispatch.shipmentNumber}",
              ),

              Text(
                "Vehicle : ${dispatch.vehiclePlate}",
              ),

              Text(
                "Driver : ${dispatch.driverName}",
              ),

              const SizedBox(height: 8),

              Text(
                "Dispatch Date : "
                    "${dispatch.dispatchDate.toLocal()}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}