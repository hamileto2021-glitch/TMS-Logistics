import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../tracking/services/trip_tracking_manager.dart';

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

  bool _starting = false;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  Future<void> _startTrip() async {
    final service = TripService();

    setState(() {
      _starting = true;
    });

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
    } finally {
      if (mounted) {
        setState(() {
          _starting = false;
        });
      }
    }
  }
  Future<void> _navigateToDestination() async {
    final destination = Uri.encodeComponent(trip.destination);

    final googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving";

    final uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open Google Maps."),
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
                    buildRow("Driver", trip.driver),
                    buildRow("Vehicle", trip.vehicle),
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
                      : trip.status == "In Progress"
                      ? "COMPLETE DELIVERY"
                      : "VIEW SUMMARY",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _starting
                    ? null
                    : () async {
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
            ),const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.navigation),
                label: const Text(
                  "NAVIGATE",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _navigateToDestination,
              ),
            ),
          ],
        ),
      ),
    );
  }
}