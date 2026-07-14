import '../core/api/base_api_service.dart';
import '../core/api/api_endpoints.dart';

import '../models/customer.dart';

class CustomerService extends BaseApiService {
  Future<List<Customer>> getCustomers() async {
    final response = await get<List<Customer>>(
      ApiEndpoints.customers,
          (data) => (data as List)
          .map((e) => Customer.fromJson(e))
          .toList(),
    );

    return response.data;
  }
}