import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LiveMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  GoogleMapController? _controller;

  late Marker _truckMarker;

  @override
  void initState() {
    super.initState();

    _truckMarker = Marker(
      markerId: const MarkerId("truck"),
      position: LatLng(
        widget.latitude,
        widget.longitude,
      ),
      infoWindow: const InfoWindow(
        title: "Driver",
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _moveTruck();
    }
  }

  Future<void> _moveTruck() async {
    final position = LatLng(
      widget.latitude,
      widget.longitude,
    );

    setState(() {
      _truckMarker = Marker(
        markerId: const MarkerId("truck"),
        position: position,
        infoWindow: const InfoWindow(
          title: "Driver",
        ),
      );
    });

    await _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 17,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final position = LatLng(
      widget.latitude,
      widget.longitude,
    );

    return SizedBox(
      height: 320,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 16,
        ),

        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,

        markers: {
          _truckMarker,
        },

        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}