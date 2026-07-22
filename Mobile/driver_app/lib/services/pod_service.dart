import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../models/proof_of_delivery.dart';

class PodService {
  Future<void> submit(ProofOfDelivery pod) async {
    await ApiClient.dio.post(
      ApiEndpoints.proofOfDelivery,
      data: pod.toJson(),
    );
  }
}