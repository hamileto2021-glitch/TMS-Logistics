import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/proof_of_delivery_model.dart';

class ProofOfDeliveryService {
  Future<void> submit(ProofOfDeliveryModel pod) async {
    final formData = FormData.fromMap({
      "tripId": pod.tripId,
      "receiverName": pod.receiverName,
      "notes": pod.notes,
      "latitude": pod.latitude,
      "longitude": pod.longitude,

      "signature": await MultipartFile.fromFile(
        pod.signaturePath,
        filename: "signature.png",
      ),

      "photo": await MultipartFile.fromFile(
        pod.photoPath,
        filename: "delivery.jpg",
      ),
    });

    final response = await ApiClient.dio.post(
      ApiEndpoints.proofOfDeliveryUpload,
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to submit Proof of Delivery");
    }
  }
}