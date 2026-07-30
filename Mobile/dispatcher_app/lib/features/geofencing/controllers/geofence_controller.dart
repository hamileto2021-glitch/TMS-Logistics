import 'package:flutter/foundation.dart';

import '../models/geofence.dart';
import '../services/geofence_service.dart';

class GeofenceController extends ChangeNotifier {
  final GeofenceService _service = GeofenceService();

  final List<Geofence> _geofences = [];
  bool _isLoading = false;
  String? _error;

  List<Geofence> get geofences => List.unmodifiable(_geofences);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadGeofences() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getAll();

      _geofences
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadGeofences();
  }

  Future<void> create(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.create(data);
      await loadGeofences();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(
      int id,
      Map<String, dynamic> data,
      ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.update(id, data);
      await loadGeofences();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.delete(id);
      await loadGeofences();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Geofence? getById(int id) {
    try {
      return _geofences.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Geofence> search(String query) {
    if (query.trim().isEmpty) {
      return geofences;
    }

    final q = query.toLowerCase();

    return _geofences.where((g) {
      return g.name.toLowerCase().contains(q) ||
          g.type.toLowerCase().contains(q);
    }).toList();
  }
}