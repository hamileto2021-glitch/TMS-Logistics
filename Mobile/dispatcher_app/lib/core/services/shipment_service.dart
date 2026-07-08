import 'package:dio/dio.dart';

import '../../models/shipment.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

class ShipmentService {
  final TokenStorage _storage = TokenStorage();

  Future<Options> _options() async {
    final token = await _storage.getToken();

    return Options(
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }

  // ==========================
  // GET ALL SHIPMENTS
  // ==========================
  Future<List<Shipment>> getShipments() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.shipments,
      options: await _options(),
    );

    final List data = response.data;

    return data
        .map((e) => Shipment.fromJson(e))
        .toList();
  }

  // ==========================
  // GET SHIPMENT BY ID
  // ==========================
  Future<Shipment> getShipment(int id) async {
    final response = await ApiClient.dio.get(
      "${ApiEndpoints.shipments}/$id",
      options: await _options(),
    );

    return Shipment.fromJson(response.data);
  }

  // ==========================
  // CREATE SHIPMENT
  // ==========================
  Future<void> createShipment(Shipment shipment) async {
    await ApiClient.dio.post(
      ApiEndpoints.shipments,
      data: shipment.toJson(),
      options: await _options(),
    );
  }

  // ==========================
  // UPDATE SHIPMENT
  // ==========================
  Future<void> updateShipment(Shipment shipment) async {
    await ApiClient.dio.put(
      "${ApiEndpoints.shipments}/${shipment.id}",
      data: shipment.toJson(),
      options: await _options(),
    );
  }

  // ==========================
  // DELETE SHIPMENT
  // ==========================
  Future<void> deleteShipment(int id) async {
    await ApiClient.dio.delete(
      "${ApiEndpoints.shipments}/$id",
      options: await _options(),
    );
  }
}