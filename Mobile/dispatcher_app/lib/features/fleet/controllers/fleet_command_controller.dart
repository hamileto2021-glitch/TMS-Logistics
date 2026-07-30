import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/services/signalr_service.dart';
import '../../notifications/controllers/notification_controller.dart';
import '../../notifications/models/geofence_notification.dart';
import '../models/fleet_summary.dart';
import '../models/live_trip.dart';
import '../services/fleet_service.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../tracking/models/live_location_update.dart';
import '../models/fleet_alert.dart';
import '../models/fleet_analytics.dart';

class FleetCommandController extends ChangeNotifier {
  FleetCommandController({
    FleetService? fleetService,
    required NotificationController notificationController,
  })  : _fleetService = fleetService ?? FleetService(),
        _notificationController = notificationController;

  final FleetService _fleetService;
  FleetAnalytics? _analytics;

  final List<LiveTrip> _allTrips = [];
  final NotificationController _notificationController;

  final List<FleetAlert> _alerts = [];
  List<FleetAlert> get alerts =>
      List.unmodifiable(_alerts);

  List<LiveTrip> _visibleTrips = [];

  LiveTrip? _selectedTrip;

  Timer? _refreshTimer;

  bool _isLoading = false;

  String _search = '';

  String _status = 'All';

  bool get isLoading => _isLoading;
  FleetAnalytics? get analytics => _analytics;


  List<LiveTrip> get trips => List.unmodifiable(_visibleTrips);

  LiveTrip? get selectedTrip => _selectedTrip;

  String get selectedStatus => _status;

  Future<void> initialize() async {
    await refresh();

    await SignalRService.instance.connect(
      baseUrl: ApiEndpoints.baseUrl,
      onLocationUpdated: _onLocationUpdated,
      onFleetAlert: _onFleetAlert,

      onGeofenceEvent: (json) {
        _notificationController.addNotification(
          GeofenceNotification.fromJson(
            Map<String, dynamic>.from(json),
          ),
        );
      },
    );

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
          (_) async {
        if (SignalRService.instance.state != HubConnectionState.Connected) {
          await refresh();
        }
      },
    );
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _fleetService.getLiveTrips(),
        _fleetService.getFleetAnalytics(),
      ]);

      final trips = results[0] as List<LiveTrip>;
      final analytics = results[1] as FleetAnalytics;

      _allTrips
        ..clear()
        ..addAll(trips);

      _analytics = analytics;

      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    _search = value.trim().toLowerCase();
    _applyFilters();
  }

  void filter(String status) {
    _status = status;
    _applyFilters();
  }

  void selectTrip(LiveTrip trip) {
    _selectedTrip = trip;
    notifyListeners();
  }
  void _onFleetAlert(dynamic data) {
    if (data is! Map<String, dynamic>) return;

    final alert = FleetAlert.fromJson(data);

    _alerts.insert(0, alert);

    if (_alerts.length > 100) {
      _alerts.removeLast();
    }

    notifyListeners();
  }
  void selectTripById(int tripId) {
    for (final trip in _allTrips) {
      if (trip.tripId == tripId) {
        _selectedTrip = trip;
        notifyListeners();
        return;
      }
    }
  }

  void _applyFilters() {
    Iterable<LiveTrip> result = _allTrips;

    if (_status != 'All') {
      result = result.where((e) => e.status == _status);
    }

    if (_search.isNotEmpty) {
      result = result.where(
            (e) =>
        e.tripNumber.toLowerCase().contains(_search) ||
            e.driverName.toLowerCase().contains(_search) ||
            e.vehiclePlate.toLowerCase().contains(_search),
      );
    }

    _visibleTrips = result.toList();

    notifyListeners();
  }
  void _onLocationUpdated(dynamic data) {
    if (data is! Map<String, dynamic>) return;

    final update = LiveLocationUpdate.fromJson(data);

    final index = _allTrips.indexWhere(
          (trip) => trip.tripId == update.tripId,
    );

    if (index == -1) return;

    _allTrips[index] = _allTrips[index].copyWith(
      latitude: update.latitude,
      longitude: update.longitude,
      speed: update.speed,
      recordedAt: DateTime.now(),
    );

    _applyFilters();
  }

  Set<Marker> get markers {
    return _visibleTrips.map((trip) {
      return Marker(
        markerId: MarkerId(trip.tripId.toString()),
        position: LatLng(
          trip.latitude,
          trip.longitude,
        ),
        infoWindow: InfoWindow(
          title: trip.vehiclePlate,
          snippet: trip.driverName,
        ),
        onTap: () => selectTrip(trip),
      );
    }).toSet();
  }

  FleetSummary get summary {
    return FleetSummary(
      activeTrips:
      _allTrips.where((e) => e.status == 'In Progress').length,
      delayedTrips:
      _allTrips.where((e) => e.status == 'Delayed').length,
      completedTrips:
      _allTrips.where((e) => e.status == 'Completed').length,
      idleVehicles:
      _allTrips.where((e) => e.speed == 0).length,
      activeDrivers: _allTrips.length,
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    SignalRService.instance.disconnect();
    super.dispose();
  }
}