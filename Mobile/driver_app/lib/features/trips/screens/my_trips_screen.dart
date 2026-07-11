import 'package:flutter/material.dart';

import '../models/driver_trip.dart';
import '../services/trip_service.dart';
import '../widgets/trip_card.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final TripService _service = TripService();

  late Future<List<DriverTrip>> _futureTrips;

  @override
  void initState() {
    super.initState();
    _futureTrips = _service.getMyTrips();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureTrips = _service.getMyTrips();
    });

    await _futureTrips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Trips"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<DriverTrip>>(
          future: _futureTrips,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final trips = snapshot.data ?? [];

            if (trips.isEmpty) {
              return const Center(
                child: Text("No trips assigned."),
              );
            }

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return TripCard(
                  trip: trips[index],
                  onTap: () {
                    // Next sprint:
                    // Navigate to TripDetailsScreen
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}