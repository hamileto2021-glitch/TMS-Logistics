import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../fleet/models/live_trip.dart';
import '../../fleet/screens/live_fleet_screen.dart';
import '../../fleet/services/fleet_service.dart';

class DashboardLiveMap extends StatefulWidget {
  const DashboardLiveMap({super.key});

  @override
  State<DashboardLiveMap> createState() => _DashboardLiveMapState();
}

class _DashboardLiveMapState extends State<DashboardLiveMap> {
  final FleetService _service = FleetService();

  List<LiveTrip> trips = [];

  Timer? _timer;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    _loadTrips();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _loadTrips(),
    );
  }

  Future<void> _loadTrips() async {
    try {
      final data = await _service.getLiveTrips();

      if (!mounted) return;

      setState(() {
        trips = data;
      });

      if (data.isNotEmpty && _mapController != null) {
        final first = data.first;

        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(first.latitude, first.longitude),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Set<Marker> _buildMarkers() {
    return trips.map((trip) {
      return Marker(
        markerId: MarkerId(trip.tripNumber),

        position: LatLng(
          trip.latitude,
          trip.longitude,
        ),

        infoWindow: InfoWindow(
          title: trip.vehiclePlate,
          snippet:
          "${trip.driverName}\n${trip.speed.toStringAsFixed(0)} km/h",
        ),
      );
    }).toSet();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  "Live Fleet Map",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(
                      8.9806,
                      38.7578,
                    ),
                    zoom: 10,
                  ),

                  markers: _buildMarkers(),

                  zoomControlsEnabled: true,

                  myLocationButtonEnabled: false,

                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text("Open Full Tracking"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const LiveFleetScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}