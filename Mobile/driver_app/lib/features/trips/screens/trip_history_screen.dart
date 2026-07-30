import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trip_provider.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() =>
      _TripHistoryScreenState();
}

class _TripHistoryScreenState
    extends State<TripHistoryScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TripProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip History"),
      ),
      body: Consumer<TripProvider>(
        builder: (_, provider, __) {

          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.history.isEmpty) {
            return const Center(
              child: Text("No Trip History"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadHistory();
            },
            child: ListView.builder(
              itemCount: provider.history.length,
              itemBuilder: (_, index) {
                final trip = provider.history[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(trip.tripNumber),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.customerName),
                        Text("${trip.origin} → ${trip.destination}"),
                        Text("Distance: ${trip.distanceKm} km"),
                        Text("Fuel: ${trip.fuelUsed} L"),
                        Text("Status: ${trip.status}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}