import '../../models/vehicle.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class VehicleService {

  Future<List<Vehicle>> getVehicles() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.vehicles,
    );

    final List list = response.data;

    return list.map((e) => Vehicle.fromJson(e)).toList();
  }

  Future<Vehicle> getVehicle(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.vehicles}/$id",
    );

    return Vehicle.fromJson(response.data);
  }

  Future<void> createVehicle(Vehicle vehicle) async {
    await ApiClient.dio.post(
      ApiEndpoints.vehicles,
      data: vehicle.toJson(),
    );
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.vehicles}/${vehicle.id}",
      data: vehicle.toJson(),
    );
  }

  Future<void> deleteVehicle(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.vehicles}/$id",
    );
  }
}