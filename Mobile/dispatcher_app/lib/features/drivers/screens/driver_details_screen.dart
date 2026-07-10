import 'package:flutter/material.dart';

import '../../../models/driver.dart';

class DriverDetailsScreen extends StatelessWidget {
  final Driver driver;

  const DriverDetailsScreen({
    super.key,
    required this.driver,
  });

  Widget infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color statusColor() {
    switch (driver.status) {
      case "Available":
        return Colors.green;

      case "Assigned":
        return Colors.orange;

      case "Inactive":
        return Colors.red;

      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              driver.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Chip(
              backgroundColor: statusColor(),
              label: Text(
                driver.status,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            infoTile(
              Icons.badge,
              "Driver Number",
              driver.driverNumber,
            ),

            infoTile(
              Icons.phone,
              "Phone",
              driver.phoneNumber,
            ),

            infoTile(
              Icons.email,
              "Email",
              driver.email,
            ),

            infoTile(
              Icons.home,
              "Address",
              driver.address,
            ),

            infoTile(
              Icons.credit_card,
              "License Number",
              driver.licenseNumber,
            ),

            infoTile(
              Icons.calendar_month,
              "License Expiry",
              driver.licenseExpiry == null
                  ? "-"
                  : driver.licenseExpiry!
                  .toString()
                  .substring(0, 10),
            ),

            infoTile(
              Icons.local_shipping,
              "Assigned Vehicle",
              driver.vehicleId == null
                  ? "Not Assigned"
                  : "Vehicle ID: ${driver.vehicleId}",
            ),
          ],
        ),
      ),
    );
  }
}