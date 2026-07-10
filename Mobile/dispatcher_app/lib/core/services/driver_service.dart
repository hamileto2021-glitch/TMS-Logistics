import '../../models/driver.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class DriverService {

  // ===========================
  // GET ALL DRIVERS
  // ===========================
  Future<List<Driver>> getDrivers() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.drivers,
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