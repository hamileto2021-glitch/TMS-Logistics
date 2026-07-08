import 'package:dio/dio.dart';

import '../../models/driver.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

class DriverService {
  final TokenStorage _storage = TokenStorage();

  Future<Options> _options() async {
    final token = await _storage.getToken();

    return Options(
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }

  // ===========================
  // GET ALL DRIVERS
  // ===========================
  Future<List<Driver>> getDrivers() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.drivers,
      options: await _options(),
    );

    final List data = response.data;

    return data.map((e) => Driver.fromJson(e)).toList();
  }

  // ===========================
  // GET DRIVER BY ID
  // ===========================
  Future<Driver> getDriver(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.drivers}/$id",
      options: await _options(),
    );

    return Driver.fromJson(response.data);
  }

  // ===========================
  // CREATE DRIVER
  // ===========================
  Future<void> createDriver(Driver driver) async {
    await ApiClient.dio.post(
      ApiEndpoints.drivers,
      data: driver.toJson(),
      options: await _options(),
    );
  }

  // ===========================
  // UPDATE DRIVER
  // ===========================
  Future<void> updateDriver(Driver driver) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.drivers}/${driver.id}",
      data: driver.toJson(),
      options: await _options(),
    );
  }

  // ===========================
  // DELETE DRIVER
  // ===========================
  Future<void> deleteDriver(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.drivers}/$id",
      options: await _options(),
    );
  }
}