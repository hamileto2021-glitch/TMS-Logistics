import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'location_service.dart';
import '../../features/tracking/services/tracking_service.dart';

class TrackingManager {
  TrackingManager._();

  static final TrackingManager instance = TrackingManager._();

  final LocationService _locationService = LocationService();
  final TrackingService _trackingService = TrackingService();

  StreamSubscription<Position>? _subscription;

  bool get isTracking => _subscription != null;

  Future<void> startTracking(int tripId) async {
    if (_subscription != null) {
      return;
    }

    await _locationService.requestPermission();

    _subscription = _locationService.locationStream().listen(
          (position) async {
        try {
          await _trackingService.saveLocation(
            tripId: tripId,
            latitude: position.latitude,
            longitude: position.longitude,
            speed: position.speed,
            heading: position.heading,
          );
        } catch (e) {
          // Prevent stream termination if a single upload fails.
          print("Tracking Error: $e");
        }
      },
      onError: (e) {
        print("Location Stream Error: $e");
      },
    );
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}