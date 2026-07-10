import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/dashboard.dart';

class DashboardService {
  Future<Dashboard> getDashboard() async {
    final Response response = await ApiClient.dio.get(
      ApiEndpoints.dashboard,
    );

    return Dashboard.fromJson(response.data);
  }
}