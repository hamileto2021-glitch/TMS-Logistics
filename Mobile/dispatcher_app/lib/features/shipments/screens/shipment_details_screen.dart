import 'package:flutter/material.dart';

import '../../../models/shipment.dart';

class ShipmentDetailsScreen extends StatelessWidget {
  final Shipment shipment;

  const ShipmentDetailsScreen({
    super.key,
    required this.shipment,
  });

  Color _statusColor() {
    switch (shipment.status) {
      case "Pending":
        return Colors.orange;

      case "Dispatched":
        return Colors.blue;

      case "In Transit":
        return Colors.deepPurple;

      case "Delivered":
        return Colors.green;

      case "Cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Widget infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shipment Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange.shade100,
              child: const Icon(
                Icons.inventory_2,
                size: 55,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              shipment.shipmentNumber,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Chip(
              backgroundColor: _statusColor(),
              label: Text(
                shipment.status,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            infoTile(
              Icons.confirmation_number,
              "Shipment Number",
              shipment.shipmentNumber,
            ),

            infoTile(
              Icons.person,
              "Customer ID",
              shipment.customerId.toString(),
            ),

            infoTile(
              Icons.local_shipping,
              "Vehicle ID",
              shipment.vehicleId?.toString() ?? "Not Assigned",
            ),

            infoTile(
              Icons.badge,
              "Driver ID",
              shipment.driverId?.toString() ?? "Not Assigned",
            ),

            infoTile(
              Icons.location_on,
              "Origin",
              shipment.origin,
            ),

            infoTile(
              Icons.flag,
              "Destination",
              shipment.destination,
            ),

            infoTile(
              Icons.inventory,
              "Cargo Type",
              shipment.cargoType,
            ),

            infoTile(
              Icons.scale,
              "Weight",
              "${shipment.weight} Kg",
            ),

            infoTile(
              Icons.straighten,
              "Volume",
              "${shipment.volume} m³",
            ),

            infoTile(
              Icons.all_inbox,
              "Packages",
              shipment.numberOfPackages.toString(),
            ),

            infoTile(
              Icons.calendar_today,
              "Booking Date",
              shipment.bookingDate
                  .toString()
                  .substring(0, 10),
            ),

            infoTile(
              Icons.event,
              "Dispatch Date",
              shipment.dispatchDate == null
                  ? "-"
                  : shipment.dispatchDate!
                  .toString()
                  .substring(0, 10),
            ),

            infoTile(
              Icons.event_available,
              "Expected Delivery",
              shipment.expectedDeliveryDate == null
                  ? "-"
                  : shipment.expectedDeliveryDate!
                  .toString()
                  .substring(0, 10),
            ),

            infoTile(
              Icons.notes,
              "Notes",
              shipment.notes,
            ),
          ],
        ),
      ),
    );
  }
}