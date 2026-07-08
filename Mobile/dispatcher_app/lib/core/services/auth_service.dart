

import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

import '../../models/login_request.dart';
import '../../models/login_response.dart';

class AuthService {
  final TokenStorage _storage = TokenStorage();

  Future<LoginResponse> login(LoginRequest request) async {
    print("==================================");
    print("LOGIN REQUEST");
    print(request.toJson());

    final response = await ApiClient.dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY:");
    print(response.data);
    print("==================================");

    final loginResponse = LoginResponse.fromJson(response.data);

    await _storage.saveToken(loginResponse.token);

    return loginResponse;
  }
}
