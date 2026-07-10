import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';

import '../models/vehicle_location.dart';

class TrackingService {
  Future<VehicleLocation> getCurrentLocation(int tripId) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.tracking}/current/$tripId",
    );

    return VehicleLocation.fromJson(response.data);
  }
}