import 'package:flutter/material.dart';

import '../models/live_trip.dart';

class VehicleInfoBottomSheet extends StatelessWidget {
  final LiveTrip? trip;
  final VoidCallback? onOpenMap;

  const VehicleInfoBottomSheet({
    super.key,
    required this.trip,
    this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    if (trip == null) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text('Select a vehicle on the map'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip!.vehiclePlate,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('Driver: ${trip!.driverName}'),
            Text('Trip: ${trip!.tripNumber}'),
            Text('Origin: ${trip!.origin}'),
            Text('Destination: ${trip!.destination}'),
            Text('Speed: ${trip!.speed.toStringAsFixed(0)} km/h'),
            Text('Status: ${trip!.status}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onOpenMap,
                icon: const Icon(Icons.map),
                label: const Text('Open Live Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}