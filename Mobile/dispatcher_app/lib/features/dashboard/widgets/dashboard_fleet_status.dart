import 'package:flutter/material.dart';

class DashboardFleetStatus extends StatelessWidget {
  final int availableVehicles;
  final int busyVehicles;
  final int availableDrivers;
  final int activeTrips;

  const DashboardFleetStatus({
    super.key,
    required this.availableVehicles,
    required this.busyVehicles,
    required this.availableDrivers,
    required this.activeTrips,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fleet Status",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _statusTile(
              Icons.directions_bus,
              "Available Vehicles",
              availableVehicles,
              Colors.green,
            ),

            const Divider(),

            _statusTile(
              Icons.local_shipping,
              "Busy Vehicles",
              busyVehicles,
              Colors.orange,
            ),

            const Divider(),

            _statusTile(
              Icons.person,
              "Available Drivers",
              availableDrivers,
              Colors.blue,
            ),

            const Divider(),

            _statusTile(
              Icons.route,
              "Trips In Progress",
              activeTrips,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusTile(IconData icon, String title, int value, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: Text(
        value.toString(),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
