import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

import '../../models/customer.dart';

class CustomerService {Future<void> createCustomer(Customer customer) async {
  final token = await _storage.getToken();

  await ApiClient.dio.post(
    ApiEndpoints.customers,
    data: customer.toJson(),
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );
}

Future<void> updateCustomer(Customer customer) async {
  final token = await _storage.getToken();

  await ApiClient.dio.put(
    "${ApiEndpoints.customers}/${customer.id}",
    data: customer.toJson(),
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );
}
  final TokenStorage _storage = TokenStorage();

  Future<List<Customer>> getCustomers() async {
    final token = await _storage.getToken();

    final response = await ApiClient.dio.get(
      ApiEndpoints.customers,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    final List data = response.data;

    return data.map((e) => Customer.fromJson(e)).toList();
  }

  Future<Customer> getCustomer(int id) async {
    final token = await _storage.getToken();

    final response = await ApiClient.dio.get(
      "${ApiEndpoints.customers}/$id",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return Customer.fromJson(response.data);
  }

  Future<void> deleteCustomer(int id) async {
    final token = await _storage.getToken();

    await ApiClient.dio.delete(
      "${ApiEndpoints.customers}/$id",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}