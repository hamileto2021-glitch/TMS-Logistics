import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/vehicle_location.dart';
import '../services/tracking_service.dart';
import 'dart:async';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final TrackingService _trackingService = TrackingService();

  GoogleMapController? _mapController;

  VehicleLocation? _currentLocation;

  Set<Marker> _markers = {};
  Timer? _timer;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();

    _loadCurrentLocation();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _loadCurrentLocation(),
    );
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final location = await _trackingService.getCurrentLocation(1);

      debugPrint("Latitude : ${location.latitude}");
      debugPrint("Longitude: ${location.longitude}");

      setState(() {
        _currentLocation = location;

        _markers = {
          Marker(
            markerId: const MarkerId("truck"),
            position: LatLng(
              location.latitude,
              location.longitude,
            ),
            infoWindow: InfoWindow(
              title: "Trip ${location.tripId}",
              snippet:
              "Speed: ${location.speed.toStringAsFixed(1)} km/h",
            ),
          ),
        };
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              location.latitude,
              location.longitude,
            ),
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Tracking Error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Vehicle Tracking"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCurrentLocation,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              compassEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),

          Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _currentLocation == null
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vehicle Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text("Trip ID : ${_currentLocation!.tripId}"),

                  Text(
                    "Latitude : ${_currentLocation!.latitude}",
                  ),

                  Text(
                    "Longitude : ${_currentLocation!.longitude}",
                  ),

                  Text(
                    "Speed : ${_currentLocation!.speed} km/h",
                  ),

                  Text(
                    "Heading : ${_currentLocation!.heading}",
                  ),

                  Text(
                    "Updated : ${_currentLocation!.recordedAt}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}