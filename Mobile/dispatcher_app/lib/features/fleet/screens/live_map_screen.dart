import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tracking/models/vehicle_location.dart';
import '../../tracking/services/tracking_service.dart';
import '../models/live_trip.dart';

class LiveMapScreen extends StatefulWidget {
  final LiveTrip trip;

  const LiveMapScreen({
    super.key,
    required this.trip,
  });

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  GoogleMapController? _controller;

  final TrackingService _service = TrackingService();

  Timer? _timer;

  LatLng? _currentPosition;

  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    _currentPosition = LatLng(
      widget.trip.latitude,
      widget.trip.longitude,
    );

    _updateMarker();

    _loadRoute();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _refreshLocation(),
    );
  }

  Future<void> _loadRoute() async {
    try {
      final List<VehicleLocation> history =
      await _service.getTripHistory(widget.trip.tripId);

      final points = history
          .map(
            (e) => LatLng(
          e.latitude,
          e.longitude,
        ),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId("trip_route"),
            points: points,
            width: 5,
            color: Colors.blue,
          ),
        };
      });
    } catch (e) {
      debugPrint("Route Error: $e");
    }
  }

  Future<void> _refreshLocation() async {
    try {
      final VehicleLocation location =
      await _service.getCurrentLocation(widget.trip.tripId);

      final LatLng newPosition = LatLng(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = newPosition;

        _updateMarker();
      });

      await _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Tracking Error: $e");
    }
  }

  void _updateMarker() {
    if (_currentPosition == null) return;

    _markers = {
      Marker(
        markerId: const MarkerId("truck"),
        position: _currentPosition!,
        infoWindow: InfoWindow(
          title: widget.trip.vehiclePlate,
          snippet:
          "${widget.trip.driverName} • ${widget.trip.speed.toStringAsFixed(0)} km/h",
        ),
      ),
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.tripNumber),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (controller) {
              _controller = controller;
            },
          ),

          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.trip.tripNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("👤 Driver: ${widget.trip.driverName}"),
                    Text("🚚 Vehicle: ${widget.trip.vehiclePlate}"),
                    Text("📍 Origin: ${widget.trip.origin}"),
                    Text("🏁 Destination: ${widget.trip.destination}"),
                    Text(
                        "⚡ Speed: ${widget.trip.speed.toStringAsFixed(0)} km/h"),
                    Text("🟢 Status: ${widget.trip.status}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}