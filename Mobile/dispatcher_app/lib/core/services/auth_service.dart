
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../storage/token_storage.dart';

import '../../models/login_request.dart';
import '../../models/login_response.dart';

class AuthService {
  final TokenStorage _storage = TokenStorage();

  Future<LoginResponse> login(LoginRequest request) async {
    print("\n🔐 ========== LOGIN START ==========");
    print("Email: ${request.email}");

    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      print("Status: ${response.statusCode}");
      print("Response type: ${response.data.runtimeType}");
      print("Response data: ${response.data}");

      if (response.statusCode != 200) {
        print("❌ Login failed with status: ${response.statusCode}");
        throw Exception("Login failed: ${response.statusCode}");
      }

      if (response.data is! Map) {
        print("❌ Unexpected response format. Expected Map, got ${response.data.runtimeType}");
        throw Exception("Invalid response format: ${response.data.runtimeType}");
      }

      print("✅ Login response received");

      final loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.token.isNotEmpty) {
        print("Token received: ${loginResponse.token.substring(0, loginResponse.token.length > 30 ? 30 : loginResponse.token.length)}...");
      } else {
        print("⚠️ Warning: Received empty token");
      }

      print("\n💾 Saving token to storage...");
      await _storage.saveToken(loginResponse.token);
      
      // Verify token was saved
      final verifyToken = await _storage.getToken();
      if (verifyToken == null || verifyToken.isEmpty) {
        print("❌ Token verification failed - token not in storage after save!");
        throw Exception("Failed to save token");
      }
      print("✅ Token verification: Token is in storage");

      print("\n✅ ========== LOGIN SUCCESS ==========\n");

      return loginResponse;
    } catch (e) {
      print("❌ Login error: $e");
      rethrow;
    }
  }
}
