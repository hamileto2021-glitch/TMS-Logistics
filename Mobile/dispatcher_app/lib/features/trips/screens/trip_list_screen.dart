import 'package:flutter/material.dart';

import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_empty_state.dart';

import '../models/trip.dart';
import '../services/trip_service.dart';

import '../widgets/trip_card.dart';
import '../widgets/trip_statistics.dart';

import 'trip_details_screen.dart';
import 'trip_form_screen.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() =>
      _TripListScreenState();
}

class _TripListScreenState
    extends State<TripListScreen> {

  final TripService _service = TripService();

  late Future<List<Trip>> _future;

  String search = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.getTrips();
  }

  Future<void> _refresh() async {
    setState(() {
      _load();
    });

    await _future;
  }

  List<Trip> _filter(List<Trip> trips) {

    if (search.isEmpty) return trips;

    final q = search.toLowerCase();

    return trips.where((t) {

      return t.tripNumber
          .toLowerCase()
          .contains(q) ||

          t.driverName
              .toLowerCase()
              .contains(q) ||

          t.vehiclePlateNumber
              .toLowerCase()
              .contains(q) ||

          t.shipmentNumber
              .toLowerCase()
              .contains(q);

    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Trips"),
        centerTitle: true,
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Trip"),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const TripFormScreen(),
            ),
          );

          _refresh();
        },
      ),

      body: FutureBuilder<List<Trip>>(

        future: _future,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const AppLoading(
              message: "Loading trips...",
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {

            return const AppEmptyState(
              icon: Icons.route,
              title: "No Trips",
              subtitle:
              "No trips have been created.",
            );
          }

          final trips =
          _filter(snapshot.data!);

          return RefreshIndicator(

            onRefresh: _refresh,

            child: ListView(

              children: [

                Padding(
                  padding:
                  const EdgeInsets.all(16),
                  child: TextField(
                    decoration:
                    const InputDecoration(
                      hintText: "Search trip...",
                      prefixIcon:
                      Icon(Icons.search),
                      border:
                      OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),

                TripStatistics(
                  trips: trips,
                ),

                ...trips.map(
                      (trip) => TripCard(
                    trip: trip,
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TripDetailsScreen(
                                tripId: trip.id,
                              ),
                        ),
                      );

                    },
                  ),
                ),

                const SizedBox(height: 80),

              ],
            ),
          );
        },
      ),
    );
  }
}