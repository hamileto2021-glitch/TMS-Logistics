import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../models/location_model.dart';

class LocationService {
  final Dio _dio = ApiClient.dio;

  Future<void> sendLocation(LocationModel location) async {
    await _dio.post(
      "/tracking/location",
      data: location.toJson(),
    );
  }
}