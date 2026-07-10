import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/dispatch.dart';

class DispatchService {

  Future<List<Dispatch>> getDispatches() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.dispatches,
    );

    return (response.data as List)
        .map((e) => Dispatch.fromJson(e))
        .toList();
  }

  Future<Dispatch> getDispatch(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.dispatches}/$id",
    );

    return Dispatch.fromJson(response.data);
  }

  Future<void> createDispatch(
      Dispatch dispatch) async {
    await ApiClient.dio.post(
      ApiEndpoints.dispatches,
      data: dispatch.toJson(),
    );
  }

  Future<void> updateDispatch(
      Dispatch dispatch) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.dispatches}/${dispatch.id}",
      data: dispatch.toJson(),
    );
  }

  Future<void> deleteDispatch(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.dispatches}/$id",
    );
  }

  Future<void> startDispatch(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.dispatches}/$id/start",
    );
  }

  Future<void> completeDispatch(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.dispatches}/$id/complete",
    );
  }

  Future<void> cancelDispatch(int id) async {
    await ApiClient.dio.post(
      "${ApiEndpoints.dispatches}/$id/cancel",
    );
  }
}