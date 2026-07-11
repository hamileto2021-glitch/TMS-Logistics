import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../core/services/location_service.dart';
import 'services/tracking_service.dart';

class TripTrackingManager {
  final LocationService _locationService = LocationService();
  final TrackingService _trackingService = TrackingService();

  StreamSubscription<Position>? _subscription;

  bool get isTracking => _subscription != null;

  Future<void> startTracking(int tripId) async {
    if (isTracking) return;

    final granted = await _locationService.requestPermission();

    if (!granted) {
      throw Exception("Location permission denied.");
    }

    _subscription = _locationService
        .getLocationStream()
        .listen((position) async {
      await _trackingService.sendLocation(
        tripId,
        position,
      );
    });
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}