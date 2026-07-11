import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class TrackingService {
  final TokenStorage _storage = TokenStorage();

  /// Get current location of a trip
  Future<Map<String, dynamic>> getCurrentLocation(int tripId) async {
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

    return jsonDecode(response.body);
  }

  /// Get full tracking history of a trip
  Future<List<dynamic>> getTripHistory(int tripId) async {
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

    return jsonDecode(response.body);
  }
}