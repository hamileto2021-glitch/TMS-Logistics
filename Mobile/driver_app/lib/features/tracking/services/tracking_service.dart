import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../models/location_update.dart';
import '../models/current_location.dart';


class TrackingService {
  final Dio _dio = ApiClient.dio;

  Future<void> sendLocation(LocationUpdate location) async {
    await _dio.post(
      "/tracking/location",
      data: location.toJson(),
    );
  }

  Future<CurrentLocation> getCurrentLocation(int tripId) async {
    final response = await _dio.get(
      "/tracking/current/$tripId",
    );

    return CurrentLocation.fromJson(response.data);
  }
}