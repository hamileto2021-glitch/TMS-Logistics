import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../models/complete_delivery_request.dart';

class DeliveryService {
  final TokenStorage _storage = TokenStorage();

  Future<String> completeDelivery(
      int tripId,
      CompleteDeliveryRequest request,
      File? photo,
      File? signature,
      ) async {
    final token = await _storage.getToken();

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/DriverDelivery/complete/$tripId",
    );

    final multipartRequest = http.MultipartRequest(
      "POST",
      uri,
    );

    multipartRequest.headers["Authorization"] =
    "Bearer $token";

    multipartRequest.fields["receiverName"] =
        request.receiverName;

    multipartRequest.fields["receiverPhone"] =
        request.receiverPhone ?? "";

    multipartRequest.fields["notes"] =
        request.notes ?? "";

    multipartRequest.fields["latitude"] =
        request.latitude.toString();

    multipartRequest.fields["longitude"] =
        request.longitude.toString();

    if (photo != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          "Photo",
          photo.path,
        ),
      );
    }
    if (signature != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          "Signature",
          signature.path,
        ),
      );
    }

    final streamedResponse =
    await multipartRequest.send();

    final response =
    await http.Response.fromStream(streamedResponse);

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return json["message"];
    }

    throw Exception(json["message"]);
  }
}