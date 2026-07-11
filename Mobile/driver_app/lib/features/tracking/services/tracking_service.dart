import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class TrackingService {
  final TokenStorage _storage = TokenStorage();

  Future<void> sendLocation(
      int tripId,
      Position position,
      ) async {

    final token = await _storage.getToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/Tracking/location"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "tripId": tripId,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "speed": position.speed,
        "heading": position.heading,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
        "Unable to send location: ${response.body}",
      );
    }
  }
}