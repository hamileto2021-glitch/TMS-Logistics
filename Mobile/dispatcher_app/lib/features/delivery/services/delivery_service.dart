import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/delivery_details.dart';

class DeliveryService {
  final TokenStorage _storage = TokenStorage();

  Future<DeliveryDetails> getDelivery(int tripId) async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/Delivery/trip/$tripId",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load delivery.");
    }

    final json = jsonDecode(response.body);

    return DeliveryDetails.fromJson(json["data"]);
  }
}