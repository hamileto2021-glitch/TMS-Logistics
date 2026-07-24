import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/report_summary.dart';

class ReportService {
  final TokenStorage _storage = TokenStorage();

  Future<ReportSummary> getSummary() async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Reports/summary"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load report summary.");
    }

    return ReportSummary.fromJson(
      jsonDecode(response.body),
    );
  }
}