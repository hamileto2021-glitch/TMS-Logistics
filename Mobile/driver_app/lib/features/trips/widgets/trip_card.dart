import 'package:flutter/material.dart';
import '../models/driver_trip.dart';

class TripCard extends StatelessWidget {
  final DriverTrip trip;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.local_shipping),
        ),
        title: Text(
          trip.tripNumber,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Shipment: ${trip.shipmentNumber}"),
            Text("${trip.origin} → ${trip.destination}"),
            Text("Status: ${trip.status}"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}