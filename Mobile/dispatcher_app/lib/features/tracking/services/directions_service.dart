import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/route_info.dart';

class DirectionsService {
  final TokenStorage _storage = TokenStorage();

  Future<RouteInfo> getRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/Tracking/route"
            "?originLat=$originLat"
            "&originLng=$originLng"
            "&destinationLat=$destinationLat"
            "&destinationLng=$destinationLng",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("GET Route");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Unable to retrieve route.");
    }

    return RouteInfo.fromJson(
      jsonDecode(response.body),
    );
  }
}