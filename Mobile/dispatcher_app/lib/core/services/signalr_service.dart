import 'package:flutter/cupertino.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  SignalRService._();

  static final SignalRService instance = SignalRService._();

  HubConnection? _connection;

  Future<void> connect({
    required String baseUrl,
    required Function(dynamic) onLocationUpdated,
    Function(dynamic)? onFleetAlert,
    Function(dynamic)? onGeofenceEvent,
  }) async {
    if (_connection?.state == HubConnectionState.Connected) {
      return;
    }

    final hubBaseUrl = baseUrl.replaceFirst('/api', '');

    _connection = HubConnectionBuilder()
        .withUrl("$hubBaseUrl/trackingHub")
        .withAutomaticReconnect()
        .build();


    _connection!.on(
      "LocationUpdated",
          (arguments) {
        debugPrint("📍 SignalR Event Received");
        debugPrint(arguments.toString());

        if (arguments != null && arguments.isNotEmpty) {
          onLocationUpdated(arguments.first);
        }
      },
    );
    _connection!.on(
      "FleetAlert",
          (arguments) {
        debugPrint("🚨 Fleet Alert Received");
        debugPrint(arguments.toString());

        if (arguments != null &&
            arguments.isNotEmpty &&
            onFleetAlert != null) {
          onFleetAlert(arguments.first);
        }
      },
    );
    _connection!.on(
      "GeofenceEvent",
          (arguments) {
        debugPrint("📍 Geofence Event Received");
        debugPrint(arguments.toString());

        if (arguments != null &&
            arguments.isNotEmpty &&
            onGeofenceEvent != null) {
          onGeofenceEvent(arguments.first);
        }
      },
    );

    await _connection!.start();
    debugPrint("✅ SignalR Connected");
  }


  Future<void> disconnect() async {
    await _connection?.stop();
  }

  HubConnectionState? get state => _connection?.state;
}