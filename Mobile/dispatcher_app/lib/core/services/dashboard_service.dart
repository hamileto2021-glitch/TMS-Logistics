import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

import '../../models/dashboard_summary.dart';

class DashboardService {
  final TokenStorage _storage = TokenStorage();

  Future<DashboardSummary> getSummary() async {
    final token = await _storage.getToken();

    final headers = <String, dynamic>{};

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await ApiClient.dio.get(
      ApiEndpoints.dashboard,
      options: Options(headers: headers),
    );

    return DashboardSummary.fromJson(response.data);
  }
}