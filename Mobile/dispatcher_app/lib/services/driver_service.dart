import '../core/api/base_api_service.dart';
import '../core/api/api_endpoints.dart';

import '../models/driver.dart';

class DriverService extends BaseApiService {
  Future<List<Driver>> getDrivers() async {
    final response = await get<List<Driver>>(
      ApiEndpoints.drivers,
          (data) => (data as List)
          .map((e) => Driver.fromJson(e))
          .toList(),
    );

    return response.data;
  }
}