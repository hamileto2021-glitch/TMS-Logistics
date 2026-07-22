import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String vehicle;
  final String plate;
  final String driver;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.plate,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Vehicle Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 18),

            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text("Vehicle"),
              subtitle: Text(vehicle),
            ),

            ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: const Text("Plate"),
              subtitle: Text(plate),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Driver"),
              subtitle: Text(driver),
            ),
          ],
        ),
      ),
    );
  }
}