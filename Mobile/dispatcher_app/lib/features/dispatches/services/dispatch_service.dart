import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/dispatch.dart';
import '../../../core/constants/api_constants.dart';

class DispatchService {
  final String baseUrl =
      "${ApiConstants.baseUrl}/dispatch";

  Future<List<Dispatch>> getDispatches() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => Dispatch.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load dispatches.");
  }

  Future<Dispatch> getDispatch(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
    );

    if (response.statusCode == 200) {
      return Dispatch.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception("Dispatch not found.");
  }

  Future<void> createDispatch(
      Dispatch dispatch) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        dispatch.toJson(),
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        "Failed to create dispatch.",
      );
    }
  }

  Future<void> updateDispatch(
      Dispatch dispatch) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${dispatch.id}"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        dispatch.toJson(),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to update dispatch.",
      );
    }
  }

  Future<void> deleteDispatch(
      int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to delete dispatch.",
      );
    }
  }

  Future<void> startDispatch(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/start"),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Unable to start dispatch.",
      );
    }
  }

  Future<void> completeDispatch(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/complete"),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Unable to complete dispatch.",
      );
    }
  }

  Future<void> cancelDispatch(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/cancel"),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Unable to cancel dispatch.",
      );
    }
  }
}