import 'package:dispatcher_app/core/services/session_manager.dart';

import '../storage/token_storage.dart';
import '../storage/user_storage.dart';
import 'auth_service.dart';

class AuthManager {
  AuthManager._();

  static final AuthManager instance = AuthManager._();

  final TokenStorage _tokenStorage = TokenStorage();

  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    final authService = AuthService();

    final valid = await authService.validateToken();

    if (!valid) {
      await logout();
      return false;
    }

    return true;
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    await SessionManager.instance.clear();
  }

  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }
}