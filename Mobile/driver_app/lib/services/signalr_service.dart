import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  HubConnection? _connection;

  final StreamController<Map<String, dynamic>> _locationController =
  StreamController.broadcast();

  Stream<Map<String, dynamic>> get locationStream =>
      _locationController.stream;

  Future<void> connect(String hubUrl) async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      return;
    }

    _connection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .build();

    _connection!.on("LocationUpdated", (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final data = Map<String, dynamic>.from(arguments.first as Map);

      _locationController.add(data);
    });

    await _connection!.start();

    print("✅ SignalR Connected");
  }

  Future<void> disconnect() async {
    await _connection?.stop();
  }

  void dispose() {
    _locationController.close();
  }
}