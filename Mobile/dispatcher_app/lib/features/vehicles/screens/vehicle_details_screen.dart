import 'package:flutter/material.dart';

import '../../../models/vehicle.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
  });

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
            ),
          ),
        ],
      ),
    );
  }

  Color statusColor() {
    switch (vehicle.status.toLowerCase()) {
      case "available":
        return Colors.green;
      case "assigned":
        return Colors.orange;
      case "maintenance":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.plateNumber),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const Icon(
                  Icons.local_shipping,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 16),

                Text(
                  vehicle.make,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  vehicle.model,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 15),

                Chip(
                  label: Text(
                    vehicle.status,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: statusColor(),
                ),

                const Divider(height: 30),

                infoTile("Vehicle Code", vehicle.vehicleCode),
                infoTile("Plate Number", vehicle.plateNumber),
                infoTile("Registration", vehicle.registrationNumber),
                infoTile("Vehicle Type", vehicle.vehicleType),
                infoTile("Year", vehicle.year.toString()),
                infoTile("Fuel Type", vehicle.fuelType),
                infoTile(
                  "Capacity Weight",
                  "${vehicle.capacityWeight} Kg",
                ),
                infoTile(
                  "Capacity Volume",
                  vehicle.capacityVolume.toString(),
                ),
                infoTile(
                  "Odometer",
                  "${vehicle.odometer} Km",
                ),
                infoTile(
                  "Insurance Number",
                  vehicle.insuranceNumber,
                ),
                infoTile(
                  "Insurance Expiry",
                  formatDate(vehicle.insuranceExpiry),
                ),
                infoTile(
                  "Road License",
                  vehicle.roadLicenseNumber,
                ),
                infoTile(
                  "Road License Expiry",
                  formatDate(vehicle.roadLicenseExpiry),
                ),
                infoTile("Notes", vehicle.notes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}