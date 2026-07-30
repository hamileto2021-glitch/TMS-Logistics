import '../../models/driver.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import 'package:dio/dio.dart';

class DriverService {

  // ===========================
  // GET ALL DRIVERS
  // ===========================
  Future<List<Driver>> getDrivers() async {
    try {
      print("Base URL: ${ApiClient.dio.options.baseUrl}");
      print("Endpoint: ${ApiEndpoints.drivers}");
      print("Full URL: ${ApiClient.dio.options.baseUrl}${ApiEndpoints.drivers}");

      final response = await ApiClient.dio.get(ApiEndpoints.drivers);

      print("========== DRIVER API ==========");
      print("Status: ${response.statusCode}");
      print("RuntimeType: ${response.data.runtimeType}");
      print(response.data);
      print("================================");

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}: ${response.data}");
      }

      final List<dynamic> data = response.data["data"];

      return data.map((e) {
        print("Driver JSON: $e");
        return Driver.fromJson(e);
      }).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        print("========== DIO ERROR ==========");
        print("Status: ${e.response!.statusCode}");
        print("URL: ${e.requestOptions.uri}");
        print("Method: ${e.requestOptions.method}");
        print("Response: ${e.response!.data}");
        print("===============================");
      } else {
        print("========== DIO ERROR ==========");
        print(e.message);
        print("===============================");
      }

      rethrow;
    }
  }

  // ===========================
  // GET DRIVER BY ID
  // ===========================
  Future<Driver> getDriver(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.drivers}/$id",
    );

    return Driver.fromJson(response.data["data"]);
  }

  // ===========================
  // CREATE DRIVER
  // ===========================
  Future<void> createDriver(Driver driver) async {
    await ApiClient.dio.post(
      ApiEndpoints.drivers,
      data: driver.toJson(),
    );
  }

  // ===========================
  // UPDATE DRIVER
  // ===========================
  Future<void> updateDriver(Driver driver) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.drivers}/${driver.id}",
      data: driver.toJson(),
    );
  }

  // ===========================
  // DELETE DRIVER
  // ===========================
  Future<void> deleteDriver(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.drivers}/$id",
    );
  }
}