import 'package:flutter/material.dart';

import '../../../core/widgets/app_status_chip.dart';
import '../../../models/vehicle.dart';
import '../screens/vehicle_details_screen.dart';
import '../screens/vehicle_form_screen.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailsScreen(
                vehicle: vehicle,
              ),
            ),
          );
        },

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(
            Icons.local_shipping,
            color: Colors.blue,
            size: 30,
          ),
        ),

        title: Text(
          vehicle.plateNumber,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                vehicle.make,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(vehicle.model),

              Text(vehicle.vehicleType),

              const SizedBox(height: 8),

              AppStatusChip(
                status: vehicle.status,
              ),
            ],
          ),
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case "details":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehicleDetailsScreen(
                      vehicle: vehicle,
                    ),
                  ),
                );
                break;

              case "edit":
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehicleFormScreen(
                      vehicle: vehicle,
                    ),
                  ),
                );

                onRefresh();
                break;

              case "delete":
                onDelete();
                break;
            }
          },

          itemBuilder: (context) => const [

            PopupMenuItem(
              value: "details",
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 10),
                  Text("Details"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 10),
                  Text("Edit"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text("Delete"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}