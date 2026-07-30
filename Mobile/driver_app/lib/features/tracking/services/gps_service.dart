import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../models/location_update.dart';
import 'tracking_service.dart';

class GpsService {
  final TrackingService _tracking = TrackingService();

  StreamSubscription<Position>? _subscription;

  Future<void> startTracking(int tripId) async {
    await Geolocator.requestPermission();

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    ).listen((position) async {
      final dto = LocationUpdate(
        tripId: tripId,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
      );

      await _tracking.sendLocation(dto);
    });
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}