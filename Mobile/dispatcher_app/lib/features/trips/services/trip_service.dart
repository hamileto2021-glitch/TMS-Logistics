import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/token_storage.dart';

import '../models/trip.dart';

class TripService {
  final TokenStorage _storage = TokenStorage();

  Future<Options> _options() async {
    final token = await _storage.getToken();

    return Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<List<Trip>> getTrips() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.trips,
      options: null,
    );

    return (response.data as List)
        .map((e) => Trip.fromJson(e))
        .toList();
  }

  Future<Trip> getTrip(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.trips}/$id",
      options: await _options(),
    );

    return Trip.fromJson(response.data);
  }

  Future<void> startTrip(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/start",
      options: await _options(),
    );
  }

  Future<void> completeTrip(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/complete",
      options: await _options(),
    );
  }

  Future<void> deleteTrip(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.trips}/$id",
      options: await _options(),
    );
  }
}