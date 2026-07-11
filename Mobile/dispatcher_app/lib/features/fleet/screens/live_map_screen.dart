import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/live_trip.dart';
import '../../tracking/services/tracking_service.dart';

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

  @override
  void initState() {
    super.initState();

    _currentPosition = LatLng(
      widget.trip.latitude,
      widget.trip.longitude,
    );

    _updateMarker();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _refreshLocation(),
    );
  }

  void _updateMarker() {
    _markers = {
      Marker(
        markerId: const MarkerId("truck"),
        position: _currentPosition!,
        infoWindow: InfoWindow(
          title: widget.trip.vehiclePlate,
          snippet: widget.trip.driverName,
        ),
      ),
    };
  }

  Future<void> _refreshLocation() async {
    try {
      final json =
      await _service.getCurrentLocation(widget.trip.tripId);

      final position = LatLng(
        (json["latitude"] as num).toDouble(),
        (json["longitude"] as num).toDouble(),
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _updateMarker();
      });

      _controller?.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    } catch (e) {
      debugPrint("Tracking Error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.tripNumber),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}