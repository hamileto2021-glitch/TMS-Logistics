import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../../models/dashboard_summary.dart';

class DashboardService {
  Future<DashboardSummary> getSummary() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.dashboard,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load dashboard");
    }

    return DashboardSummary.fromJson(response.data);
  }
}