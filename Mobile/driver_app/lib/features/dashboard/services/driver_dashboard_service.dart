import '../../../core/api/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/driver_dashboard.dart';
import 'package:dio/dio.dart';

class DriverDashboardService {
  final TokenStorage _storage = TokenStorage();

  Future<DriverDashboard> loadDashboard() async {
    final token = await _storage.getToken();

    final response = await ApiClient.dio.get(
      "/driver/dashboard",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return DriverDashboard.fromJson(response.data);
  }
}