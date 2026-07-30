import 'dart:convert';

import 'package:http/http.dart' as http;


import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/live_trip.dart';
import '../models/fleet_analytics.dart';
import '../../tracking/models/trip_replay_point.dart';



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

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Unable to load live fleet.");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => LiveTrip.fromJson(e))
        .toList();
  }
  Future<FleetAnalytics> getFleetAnalytics() async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Dashboard/fleet-analytics"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load fleet analytics.");
    }

    return FleetAnalytics.fromJson(
      jsonDecode(response.body),
    );
  }
  Future<List<TripReplayPoint>> getTripReplay(int tripId) async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Tracking/replay/$tripId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load trip replay.");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => TripReplayPoint.fromJson(e))
        .toList();
  }
}