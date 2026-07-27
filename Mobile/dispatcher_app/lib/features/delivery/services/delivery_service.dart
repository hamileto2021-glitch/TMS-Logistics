import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/delivery_details.dart';

class DeliveryService {
  final TokenStorage _storage = TokenStorage();

  Future<DeliveryDetails> getDelivery(int tripId) async {
    final token = await _storage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Delivery/trip/$tripId"),
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

  Future<void> completeDelivery({
    required int tripId,
    required String receiverName,
    required String receiverPhone,
    required String notes,
    required double latitude,
    required double longitude,
    File? photo,
    File? signature,
  }) async {
    final token = await _storage.getToken();

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "${ApiConstants.baseUrl}/Delivery/trip/$tripId/complete",
      ),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields["receiverName"] = receiverName;
    request.fields["receiverPhone"] = receiverPhone;
    request.fields["notes"] = notes;
    request.fields["latitude"] = latitude.toString();
    request.fields["longitude"] = longitude.toString();

    if (photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "photo",
          photo.path,
        ),
      );
    }

    if (signature != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "signature",
          signature.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      String message = "Failed to complete delivery.";

      try {
        final body = jsonDecode(response.body);

        if (body is Map && body["message"] != null) {
          message = body["message"].toString();
        }
      } catch (_) {
        // Keep default message if response isn't valid JSON.
      }

      throw Exception(message);
    }
  }
}