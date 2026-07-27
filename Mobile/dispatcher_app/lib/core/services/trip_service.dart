import '../api/api_client.dart';
import '../api/api_endpoints.dart';

import '../../models/trip.dart';
import '../../models/create_trip_request.dart';
import '../../models/update_trip_request.dart';

class TripService {
  Future<List<Trip>> getTrips() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.trips,
    );

    final List<dynamic> data = response.data["data"];

    return data
        .map((e) => Trip.fromJson(e))
        .toList();
  }

  Future<Trip> getTrip(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.trips}/$id",
    );

    return Trip.fromJson(response.data["data"]);
  }

  Future<void> createTrip(
      CreateTripRequest request,
      ) async {
    final response = await ApiClient.dio.post(
      ApiEndpoints.trips,
      data: request.toJson(),
    );

    print("========== CREATE TRIP ==========");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("=================================");
  }
  Future<void> updateTrip(
      int id,
      UpdateTripRequest request,
      ) async {
    final response = await ApiClient.dio.put(
      "${ApiEndpoints.trips}/$id",
      data: request.toJson(),
    );

    print("========== UPDATE TRIP ==========");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("=================================");
  }

  Future<void> pauseTrip(
      int id, {
        String? reason,
      }) async {
    final response = await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/pause",
      data: reason,
    );

    print("========== PAUSE TRIP ==========");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("================================");
  }

  Future<void> resumeTrip(int id) async {
    final response = await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/resume",
    );

    print("========== RESUME TRIP ==========");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("=================================");
  }

  Future<void> cancelTrip(int id) async {
    final response = await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/cancel",
    );

    print("========== CANCEL TRIP ==========");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("=================================");
  }

  Future<void> startTrip(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/start",
    );
  }

  Future<void> completeTrip(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.trips}/$id/complete",
    );
  }

  Future<void> deleteTrip(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.trips}/$id",
    );
  }
}