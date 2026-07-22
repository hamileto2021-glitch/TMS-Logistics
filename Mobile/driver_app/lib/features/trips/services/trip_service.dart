import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../models/active_trip.dart';
import '../models/trip_history.dart';
import '../models/driver_trip.dart';

class TripService {
  final Dio _dio = ApiClient.dio;

  Future<ActiveTrip?> getActiveTrip() async {
    final response = await _dio.get('/driver/trips/active');

    if (response.data is Map &&
        response.data['message'] == 'No active trip assigned.') {
      return null;
    }

    return ActiveTrip.fromJson(response.data);
  }

  Future<List<TripHistory>> getTripHistory() async {
    final response = await _dio.get('/driver/trips/history');

    return (response.data as List)
        .map((e) => TripHistory.fromJson(e))
        .toList();
  }

  Future<bool> startTrip(int tripId) async {
    final response = await _dio.post(
      '/driver/trips/$tripId/start',
    );

    return response.statusCode == 200;
  }

  Future<bool> pauseTrip(int tripId, String reason) async {
    final response = await _dio.post(
      '/driver/trips/$tripId/pause',
      data: reason,
    );

    return response.statusCode == 200;
  }

  Future<bool> resumeTrip(int tripId) async {
    final response = await _dio.post(
      '/driver/trips/$tripId/resume',
    );

    return response.statusCode == 200;
  }
Future<List<DriverTrip>> getMyTrips() async {
try {
  final response = await _dio.get('/DriverTrips/my-trips');

print(response.data);

return (response.data as List)
.map((e) => DriverTrip.fromJson(e))
.toList();
} catch (e) {
print("getMyTrips ERROR: $e");
rethrow;
}
}
}
