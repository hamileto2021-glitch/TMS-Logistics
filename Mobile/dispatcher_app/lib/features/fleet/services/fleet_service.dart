import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/live_trip.dart';

class FleetService {
  final TokenStorage _storage = TokenStorage();

  Future<List<LiveTrip>> getLiveTrips() async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Tracking/live"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load live fleet.");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => LiveTrip.fromJson(e))
        .toList();
  }
}