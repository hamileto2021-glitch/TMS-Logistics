import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../services/location_service.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../services/signalr_service.dart';

class TrackingProvider extends ChangeNotifier {
  final LocationService _service = LocationService();
  final SignalRService _signalR = SignalRService();

  bool uploading = false;

  Future<void> uploadLocation(LocationModel location) async {
    uploading = true;
    notifyListeners();

    try {
      await _service.sendLocation(location);
    } finally {
      uploading = false;
      notifyListeners();
    }
  }
  Future<void> initializeSignalR() async {
    await _signalR.connect(ApiEndpoints.signalRHub);

    _signalR.locationStream.listen((data) {
      print("Live location received: $data");

      // We'll update the map state here in the next step.
      notifyListeners();
    });
  }
}