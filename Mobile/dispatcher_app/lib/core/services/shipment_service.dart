import '../../models/shipment.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class ShipmentService {

  // ==========================
  // GET ALL SHIPMENTS
  // ==========================
  Future<List<Shipment>> getShipments() async {

    final response = await ApiClient.dio.get(
      ApiEndpoints.shipments,
    );

    print("========== SHIPMENT API ==========");
    print("Status: ${response.statusCode}");
    print("Type: ${response.data.runtimeType}");
    print("Response:");
    print(response.data);
    print("================================");

try {
final List<dynamic> data = response.data;

return data
.map((e) => Shipment.fromJson(e))
.toList();
} catch (e, stack) {
print("========== SHIPMENT ERROR ==========");
print(e);
print(stack);
rethrow;
}
  }
  // ==========================
  // GET SHIPMENT BY ID
  // ==========================
  Future<Shipment> getShipment(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.shipments}/$id",
    );

    return Shipment.fromJson(response.data["data"]);
  }

  // ==========================
  // CREATE SHIPMENT
  // ==========================
  Future<void> createShipment(Shipment shipment) async {
    await ApiClient.dio.post(
      ApiEndpoints.shipments,
      data: shipment.toJson(),
    );
  }

  // ==========================
  // UPDATE SHIPMENT
  // ==========================
  Future<void> updateShipment(Shipment shipment) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.shipments}/${shipment.id}",
      data: shipment.toJson(),
    );
  }

  // ==========================
  // DELETE SHIPMENT
  // ==========================
  Future<void> deleteShipment(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.shipments}/$id",
    );
  }
}