import 'package:flutter/material.dart';

import '../../customers/screens/customer_list_screen.dart';
import '../../shipments/screens/shipment_list_screen.dart';
import '../../vehicles/vehicle_list_screen.dart';
import '../../drivers/driver_list_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [

                ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text("Customers"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerListScreen(),
                      ),
                    );
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.inventory),
                  label: const Text("Shipments"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ShipmentListScreen(),
                      ),
                    );
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.fire_truck),
                  label: const Text("Vehicles"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VehicleListScreen(),
                      ),
                    );
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Drivers"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}