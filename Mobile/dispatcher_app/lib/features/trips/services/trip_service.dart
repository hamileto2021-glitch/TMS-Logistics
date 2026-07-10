import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';

import '../models/trip.dart';

class TripService {
  Future<List<Trip>> getTrips() async {
    print("Calling: ${ApiEndpoints.trips}");

    final response = await ApiClient.dio.get(
      ApiEndpoints.trips,
    );

    print(response.statusCode);

    return (response.data as List)
        .map((e) => Trip.fromJson(e))
        .toList();
  }

  Future<Trip> getTrip(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.trips}/$id",
    );

    return Trip.fromJson(response.data);
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