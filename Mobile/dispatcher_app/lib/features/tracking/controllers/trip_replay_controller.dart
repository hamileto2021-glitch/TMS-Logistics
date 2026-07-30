import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';


import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../fleet/services/fleet_service.dart';
import '../models/trip_replay_point.dart';
import 'package:flutter/material.dart';

class TripReplayController extends ChangeNotifier {
  TripReplayController({
    FleetService? fleetService,
  }) : _fleetService = fleetService ?? FleetService();

  final FleetService _fleetService;

  List<TripReplayPoint> _points = [];

  List<TripReplayPoint> get points =>
      List.unmodifiable(_points);

  int _currentIndex = 0;
  LatLng? _animatedPosition;
  double _animatedHeading = 0;
  LatLng? get animatedPosition => _animatedPosition;

  double get animatedHeading => _animatedHeading;

  int get currentIndex => _currentIndex;

  TripReplayPoint? get currentPoint =>
      _points.isEmpty ? null : _points[_currentIndex];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  double _speed = 1.0;

  double get speed => _speed;

  Timer? _timer;
  BitmapDescriptor? _truckIcon;

  Future<void> loadReplay(int tripId) async {
    await loadTruckIcon();
    _isLoading = true;
    notifyListeners();

    try {
      _points = await _fleetService.getTripReplay(tripId);

      _currentIndex = 0;

      if (_points.isNotEmpty) {
        _animatedPosition = LatLng(
          _points.first.latitude,
          _points.first.longitude,
        );

        _animatedHeading = _points.first.heading;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void play() {
    if (_points.isEmpty) return;

    if (_isPlaying) return;

    _isPlaying = true;

    notifyListeners();

    _runReplay();
  }
  Future<void> _runReplay() async {
    while (_isPlaying &&
        _currentIndex < _points.length - 1) {
      final start = _points[_currentIndex];

      _currentIndex++;

      final end = _points[_currentIndex];

      await _animateToNextPoint(
        start,
        end,
      );
    }

    _isPlaying = false;

    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void restart() {
    pause();

    _currentIndex = 0;

    notifyListeners();
  }

  void seek(int index) {
    if (_points.isEmpty) return;

    if (index < 0 || index >= _points.length) return;

    pause();

    _currentIndex = index;

    _animatedPosition = LatLng(
      _points[index].latitude,
      _points[index].longitude,
    );

    _animatedHeading = _points[index].heading;

    notifyListeners();
  }

  void changeSpeed(double value) {
    _speed = value;

    if (_isPlaying) {
      pause();
      play();
    }

    notifyListeners();
  }
  Future<void> loadTruckIcon() async {
    _truckIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(
        size: Size(64, 64),
      ),
      "assets/images/truck_marker.png",
    );

    notifyListeners();
  }
  Future<void> _animateToNextPoint(
      TripReplayPoint start,
      TripReplayPoint end,
      ) async {
    const frames = 20;

    for (int i = 1; i <= frames; i++) {
      final t = i / frames;

      final latitude =
          start.latitude +
              (end.latitude - start.latitude) * t;

      final longitude =
          start.longitude +
              (end.longitude - start.longitude) * t;

      final heading =
          start.heading +
              (end.heading - start.heading) * t;

      _animatedPosition = LatLng(
        latitude,
        longitude,
      );

      _animatedHeading = heading;

      notifyListeners();

      await Future.delayed(
        Duration(
          milliseconds:
          (1000 / frames / _speed).round(),
        ),
      );
    }
  }

  Set<Marker> get markers {
    if (_points.isEmpty) return {};

    final currentPosition =
        _animatedPosition ??
            LatLng(
              _points.first.latitude,
              _points.first.longitude,
            );

    final first = _points.first;

    final last = _points.last;

    return {
      Marker(
        markerId: const MarkerId("start"),
        position: LatLng(
          first.latitude,
          first.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        infoWindow: const InfoWindow(
          title: "Trip Start",
        ),
      ),

      Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(
          last.latitude,
          last.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: const InfoWindow(
          title: "Destination",
        ),
      ),

      Marker(
        markerId: const MarkerId("truck"),
        position: currentPosition,

        icon: _truckIcon ?? BitmapDescriptor.defaultMarker,

        rotation: _animatedHeading,
        flat: true,

        infoWindow: const InfoWindow(
          title: "Current Position",
        ),
      ),
    };
  }

  Set<Polyline> get polylines {
    if (_points.isEmpty) return {};

    final completed = _points
        .take(_currentIndex + 1)
        .map(
          (e) => LatLng(
        e.latitude,
        e.longitude,
      ),
    )
        .toList();

    final remaining = _points
        .skip(_currentIndex)
        .map(
          (e) => LatLng(
        e.latitude,
        e.longitude,
      ),
    )
        .toList();

    return {
      Polyline(
        polylineId: const PolylineId("completed"),
        color: Colors.blue,
        width: 6,
        points: completed,
      ),

      Polyline(
        polylineId: const PolylineId("remaining"),
        color: Colors.grey,
        width: 6,
        points: remaining,
      ),
    };
  }
  double get maxSpeed =>
      _points.isEmpty
          ? 0
          : _points
          .map((e) => e.speed)
          .reduce((a, b) => a > b ? a : b);

  double get averageSpeed =>
      _points.isEmpty
          ? 0
          : _points
          .map((e) => e.speed)
          .reduce((a, b) => a + b) /
          _points.length;

  Duration get tripDuration =>
      _points.length < 2
          ? Duration.zero
          : _points.last.recordedAt
          .difference(_points.first.recordedAt);

  LatLng get currentLatLng =>
      _animatedPosition ??
          LatLng(
            _points.first.latitude,
            _points.first.longitude,
          );
  double get progress {
    if (_points.isEmpty) return 0;

    return (_currentIndex + 1) / _points.length;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}