import 'package:flutter/material.dart';

import '../models/driver_dashboard.dart';
import '../services/driver_dashboard_service.dart';

class DriverDashboardProvider extends ChangeNotifier {
  final DriverDashboardService _service = DriverDashboardService();

  DriverDashboard? _dashboard;
  DriverDashboard? get dashboard => _dashboard;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadDashboard() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _dashboard = await _service.loadDashboard();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}