import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../models/driver_trip.dart';

class TripService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<DriverTrip>> getMyTrips() async {
    final token = await _tokenStorage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Driver/mytrips"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List data = json["data"];

      return data
          .map((e) => DriverTrip.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load trips");
  }
}