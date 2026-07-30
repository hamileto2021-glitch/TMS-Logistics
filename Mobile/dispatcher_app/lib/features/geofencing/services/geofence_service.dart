import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/geofence.dart';

class GeofenceService {
  Future<List<Geofence>> getAll() async {
    final Response response =
    await ApiClient.dio.get(ApiEndpoints.geofences);

    return (response.data as List)
        .map((e) => Geofence.fromJson(e))
        .toList();
  }

  Future<Geofence> getById(int id) async {
    final Response response =
    await ApiClient.dio.get('${ApiEndpoints.geofences}/$id');

    return Geofence.fromJson(response.data);
  }

  Future<void> create(Map<String, dynamic> data) async {
    await ApiClient.dio.post(
      ApiEndpoints.geofences,
      data: data,
    );
  }

  Future<void> update(
      int id,
      Map<String, dynamic> data,
      ) async {
    await ApiClient.dio.put(
      '${ApiEndpoints.geofences}/$id',
      data: data,
    );
  }

  Future<void> delete(int id) async {
    await ApiClient.dio.delete(
      '${ApiEndpoints.geofences}/$id',
    );
  }
}