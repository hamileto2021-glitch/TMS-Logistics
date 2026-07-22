import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tracking/models/vehicle_location.dart';
import '../../tracking/services/tracking_service.dart';
import '../models/live_trip.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../tracking/models/route_info.dart';
import '../../tracking/services/directions_service.dart';

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

final DirectionsService _directionsService = DirectionsService();

RouteInfo? _routeInfo;

Set<Polyline> _plannedPolyline = {};

final TrackingService _service = TrackingService();

Timer? _liveTimer;
Timer? _replayTimer;

BitmapDescriptor? _truckIcon;

LatLng? _currentPosition;

Set<Marker> _markers = {};
Set<Polyline> _polylines = {};

List<VehicleLocation> _history = [];

int _currentIndex = 0;

bool _isPlaying = false;

double _currentHeading = 0;


@override
void initState() {
super.initState();

_initialize();
}

Future<void> _initialize() async {
await _loadTruckIcon();

_currentPosition = LatLng(
widget.trip.latitude,
widget.trip.longitude,
);

_updateMarker();

await _loadRoute();
await _loadPlannedRoute();

_liveTimer = Timer.periodic(
const Duration(seconds: 5),
(_) => _refreshLocation(),
);

if (mounted) {
setState(() {});
}
}

Future<void> _loadTruckIcon() async {
_truckIcon = await BitmapDescriptor.fromAssetImage(
const ImageConfiguration(
size: Size(64, 64),
),
"assets/images/truck.png",
);
}

Future<void> _loadRoute() async {
try {
final history =
await _service.getTripHistory(widget.trip.tripId);

_history = history;

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
polylineId: const PolylineId("route"),
points: points,
width: 6,
color: Colors.blue,
),
};
});
} catch (e) {
debugPrint(e.toString());
}
}
Future<void> _loadPlannedRoute() async {
  try {
    final route = await _directionsService.getRoute(
      originLat: widget.trip.originLatitude,
      originLng: widget.trip.originLongitude,
      destinationLat: widget.trip.destinationLatitude,
      destinationLng: widget.trip.destinationLongitude,
    );

    _routeInfo = route;

    final polylinePoints = PolylinePoints();

    final result =
    polylinePoints.decodePolyline(route.encodedPolyline);

    final points = result
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    if (!mounted) return;

    setState(() {
      _plannedPolyline = {
        Polyline(
          polylineId: const PolylineId("planned_route"),
          color: Colors.green,
          width: 6,
          points: points,
        ),
      };
    });
  } catch (e) {
    debugPrint("Directions Error: $e");
  }
}
Future<void> _refreshLocation() async {
if (_isPlaying) return;

try {
final location =
await _service.getCurrentLocation(widget.trip.tripId);

_currentHeading = location.heading;

_currentPosition = LatLng(
location.latitude,
location.longitude,
);

_updateMarker();

await _loadRoute();

if (!mounted) return;

setState(() {});

await _controller?.animateCamera(
CameraUpdate.newLatLng(_currentPosition!),
);
} catch (e) {
debugPrint(e.toString());
}
}

void _updateMarker() {
if (_currentPosition == null) return;

_markers = {
Marker(
markerId: const MarkerId("truck"),
position: _currentPosition!,
rotation: _currentHeading,
flat: true,
anchor: const Offset(0.5, 0.5),
icon: _truckIcon ?? BitmapDescriptor.defaultMarker,
infoWindow: InfoWindow(
title: widget.trip.vehiclePlate,
snippet:
"${widget.trip.driverName} • ${widget.trip.speed.toStringAsFixed(0)} km/h",
),
),
};
}

void _startReplay() {
if (_history.isEmpty) return;

_liveTimer?.cancel();

_replayTimer?.cancel();

_currentIndex = 0;

setState(() {
_isPlaying = true;
});

_replayTimer = Timer.periodic(
  const Duration(milliseconds: 500),
(timer) async {
if (_currentIndex >= _history.length) {
timer.cancel();

_isPlaying = false;

_liveTimer = Timer.periodic(
const Duration(seconds: 5),
(_) => _refreshLocation(),
);

if (mounted) {
setState(() {});
}

return;
}

final point = _history[_currentIndex];

_currentHeading = point.heading;

_currentPosition = LatLng(
point.latitude,
point.longitude,
);

_updateMarker();

if (mounted) {
setState(() {
_currentIndex++;
});
}

await _controller?.animateCamera(
CameraUpdate.newLatLng(_currentPosition!),
);
},
);
}

void _pauseReplay() {
_replayTimer?.cancel();

setState(() {
_isPlaying = false;
});

_liveTimer ??= Timer.periodic(
const Duration(seconds: 5),
(_) => _refreshLocation(),
);
}

void _stopReplay() {
_replayTimer?.cancel();

if (_history.isEmpty) return;

_currentIndex = 0;

_currentHeading = _history.first.heading;

_currentPosition = LatLng(
_history.first.latitude,
_history.first.longitude,
);

_updateMarker();

setState(() {
_isPlaying = false;
});

_controller?.animateCamera(
CameraUpdate.newLatLng(_currentPosition!),
);

_liveTimer ??= Timer.periodic(
const Duration(seconds: 5),
(_) => _refreshLocation(),
);
}

@override
void dispose() {
_liveTimer?.cancel();
_replayTimer?.cancel();
_controller?.dispose();
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

          onMapCreated: (controller) {
            _controller = controller;
          },

          markers: _markers,

          polylines: {
            ..._polylines,
            ..._plannedPolyline,
          },

          myLocationEnabled: true,

          myLocationButtonEnabled: true,

          zoomControlsEnabled: true,

          compassEnabled: true,

          mapToolbarEnabled: true,
        ),

        Positioned(
          left: 10,
          right: 10,
          bottom: 20,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trip.tripNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.person, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.trip.driverName),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.local_shipping, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.trip.vehiclePlate),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.trip.origin),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.flag, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.trip.destination),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.speed, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.trip.speed.toStringAsFixed(0)} km/h",
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(widget.trip.status),
                    ],
                  ),

// ---------- ETA & Distance ----------
                  if (_routeInfo != null) ...[
                    const Divider(),

                    Row(
                      children: [
                        const Icon(Icons.route, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "${_routeInfo!.distanceKm.toStringAsFixed(1)} km remaining",
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "${_routeInfo!.durationMinutes} min ETA",
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],

// ---------- Replay Buttons ----------
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                          _isPlaying ? null : _startReplay,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play"),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                          _isPlaying ? _pauseReplay : null,
                          icon: const Icon(Icons.pause),
                          label: const Text("Pause"),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _stopReplay,
                          icon: const Icon(Icons.stop),
                          label: const Text("Stop"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  LinearProgressIndicator(
                    value: _history.isEmpty
                        ? 0
                        : _currentIndex / _history.length,
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      "Replay Progress : $_currentIndex / ${_history.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
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