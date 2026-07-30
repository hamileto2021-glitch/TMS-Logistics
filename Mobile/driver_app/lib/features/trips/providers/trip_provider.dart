import 'package:flutter/material.dart';

import '../models/active_trip.dart';
import '../models/trip_history.dart';
import '../models/driver_trip.dart';
import '../services/trip_service.dart';

class TripProvider extends ChangeNotifier {
  final TripService _service = TripService();

  ActiveTrip? activeTrip;

  List<TripHistory> history = [];

  List<DriverTrip> trips = [];

  bool loading = false;

  Future<void> loadActiveTrip() async {
    loading = true;
    notifyListeners();

    activeTrip = await _service.getActiveTrip();

    loading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    loading = true;
    notifyListeners();

    history = await _service.getTripHistory();

    loading = false;
    notifyListeners();
  }

  Future<void> startTrip() async {
    if (activeTrip == null) return;

    await _service.startTrip(activeTrip!.tripId);

    await loadActiveTrip();
  }
  Future<void> loadTrips() async {
    loading = true;
    notifyListeners();

    try {
      trips = await _service.getMyTrips();
    } catch (e) {
      debugPrint("loadTrips error: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> pauseTrip(String reason) async {
    if (activeTrip == null) return;

    await _service.pauseTrip(activeTrip!.tripId, reason);

    await loadActiveTrip();
  }

  Future<void> resumeTrip() async {
    if (activeTrip == null) return;

    await _service.resumeTrip(activeTrip!.tripId);

    await loadActiveTrip();
  }

}