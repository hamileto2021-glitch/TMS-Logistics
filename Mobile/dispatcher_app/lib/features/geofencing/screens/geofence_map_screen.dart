import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofenceMapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final double initialRadius;

  const GeofenceMapScreen({
    super.key,
    this.initialLocation,
    this.initialRadius = 100,
  });

  @override
  State<GeofenceMapScreen> createState() => _GeofenceMapScreenState();
}

class _GeofenceMapScreenState extends State<GeofenceMapScreen> {
  GoogleMapController? _controller;

  late LatLng _selectedLocation;
  late double _radius;

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();

    _selectedLocation = widget.initialLocation ??
        const LatLng(8.5402, 39.2713); // Default: Adama

    _radius = widget.initialRadius;

    _updateMapObjects();
  }

  void _updateMapObjects() {
    _markers = {
      Marker(
        markerId: const MarkerId('geofence'),
        position: _selectedLocation,
      ),
    };

    _circles = {
      Circle(
        circleId: const CircleId('geofence'),
        center: _selectedLocation,
        radius: _radius,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.25),
      ),
    };
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _updateMapObjects();
    });
  }

  void _onRadiusChanged(double value) {
    setState(() {
      _radius = value;
      _updateMapObjects();
    });
  }

  void _save() {
    Navigator.pop(
      context,
      {
        "latitude": _selectedLocation.latitude,
        "longitude": _selectedLocation.longitude,
        "radius": _radius,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Geofence"),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _controller = controller;
            },
            onTap: _onMapTap,
            markers: _markers,
            circles: _circles,
            zoomControlsEnabled: true,
            compassEnabled: true,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Radius: ${_radius.toInt()} m",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Slider(
                      value: _radius,
                      min: 50,
                      max: 5000,
                      divisions: 99,
                      label: "${_radius.toInt()} m",
                      onChanged: _onRadiusChanged,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Latitude: ${_selectedLocation.latitude.toStringAsFixed(6)}",
                    ),

                    Text(
                      "Longitude: ${_selectedLocation.longitude.toStringAsFixed(6)}",
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text("Use This Location"),
                      ),
                    ),
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