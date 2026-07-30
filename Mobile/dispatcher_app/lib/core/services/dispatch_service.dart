import '../../models/dispatch.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../../models/create_dispatch_request.dart';

class DispatchService {
  Future<List<Dispatch>> getDispatches() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.dispatches,
    );

    print("========== DISPATCH API ==========");
    print("Status: ${response.statusCode}");
    print("Type: ${response.data.runtimeType}");
    print("Response:");
    print(response.data);
    print("==================================");

    final List<dynamic> data = response.data;

    return data
        .map((e) => Dispatch.fromJson(e))
        .toList();
  }Future<void> createDispatch(
      CreateDispatchRequest request,
      ) async {

    final response = await ApiClient.dio.post(
      ApiEndpoints.dispatches,
      data: request.toJson(),
    );

    print("========== CREATE DISPATCH ==========");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("=====================================");
  }
}