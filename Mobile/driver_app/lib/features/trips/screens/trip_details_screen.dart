import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tracking/trip_tracking_manager.dart';

import '../models/driver_trip.dart';
import '../services/trip_service.dart';
import '../../delivery/screens/complete_delivery_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  final DriverTrip trip;

  const TripDetailsScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late DriverTrip trip;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  Future<void> _startTrip() async {
    final service = TripService();

    try {
      final success = await service.startTrip(trip.id);

      if (!mounted) return;

      if (success) {
        await context
            .read<TripTrackingManager>()
            .startTracking(trip.id);
        setState(() {
          trip.status = "In Progress";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Trip started successfully."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    buildRow("Trip", trip.tripNumber),
                    buildRow("Shipment", trip.shipmentNumber),
                    buildRow("Origin", trip.origin),
                    buildRow("Destination", trip.destination),
                    buildRow("Status", trip.status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: Icon(
                  trip.status == "Scheduled"
                      ? Icons.play_arrow
                      : trip.status == "In Progress"
                      ? Icons.check_circle
                      : Icons.check_circle,
                ),
                label: Text(
                  trip.status == "Scheduled"
                      ? "START TRIP"
                      : trip.status == "Started"
                      ? "COMPLETE DELIVERY"
                      : "VIEW SUMMARY",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (trip.status == "Scheduled") {
                    await _startTrip();
                  } else if (trip.status == "In Progress") {
                    print("Trip ID: ${trip.id}");
                    print("Trip Number: ${trip.tripNumber}");

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompleteDeliveryScreen(
                          trip: trip,
                        ),
                      ),
                    );

                    if (result == true && mounted) {
                      setState(() {
                        trip.status = "Completed";
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Trip already completed."),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}