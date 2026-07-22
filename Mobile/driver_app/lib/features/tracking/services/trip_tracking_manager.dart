import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../core/services/location_service.dart';
import '../../../models/location_update.dart';
import 'tracking_service.dart';

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

      final location = LocationUpdate(
        tripId: tripId,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
      );

      await _trackingService.sendLocation(location);
    });
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}