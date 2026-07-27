import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/vehicle_location.dart';

class TrackingService {
  final TokenStorage _storage = TokenStorage();

  /// Current location
  Future<VehicleLocation> getCurrentLocation(int tripId) async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Tracking/current/$tripId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("GET Current Location");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Unable to retrieve current location.");
    }

    return VehicleLocation.fromJson(
      jsonDecode(response.body),
    );
  }

  /// Trip history
  Future<List<VehicleLocation>> getTripHistory(int tripId) async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Tracking/history/$tripId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("GET Trip History");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Unable to retrieve trip history.");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => VehicleLocation.fromJson(e))
        .toList();
  }
  /// Send current GPS location to the server
  Future<void> saveLocation({
    required int tripId,
    required double latitude,
    required double longitude,
    double speed = 0,
    double heading = 0,
  }) async {
    final token = await _storage.getToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/Tracking/location"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "tripId": tripId,
        "latitude": latitude,
        "longitude": longitude,
        "speed": speed,
        "heading": heading,
      }),
    );

    print("POST Tracking Location");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Unable to save vehicle location.");
    }
  }
}