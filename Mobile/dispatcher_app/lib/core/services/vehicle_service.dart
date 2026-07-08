import 'package:dio/dio.dart';

import '../../models/vehicle.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

class VehicleService {
  final TokenStorage _storage = TokenStorage();

  Future<Options> _options() async {
    final token = await _storage.getToken();

    return Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<List<Vehicle>> getVehicles() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.vehicles,
      options: await _options(),
    );

    final List list = response.data;

    return list.map((e) => Vehicle.fromJson(e)).toList();
  }

  Future<Vehicle> getVehicle(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.vehicles}/$id",
      options: await _options(),
    );

    return Vehicle.fromJson(response.data);
  }

  Future<void> createVehicle(Vehicle vehicle) async {
    await ApiClient.dio.post(
      ApiEndpoints.vehicles,
      data: vehicle.toJson(),
      options: await _options(),
    );
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.vehicles}/${vehicle.id}",
      data: vehicle.toJson(),
      options: await _options(),
    );
  }

  Future<void> deleteVehicle(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.vehicles}/$id",
      options: await _options(),
    );
  }
}