import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/complete_delivery_request.dart';

class DeliveryService {
  final TokenStorage _storage = TokenStorage();

  Future<String> completeDelivery(
      int tripId,
      CompleteDeliveryRequest request,
      ) async {
    final token = await _storage.getToken();

    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}/DriverDelivery/complete/$tripId",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return json["message"];
    }

    throw Exception(json["message"]);
  }
}