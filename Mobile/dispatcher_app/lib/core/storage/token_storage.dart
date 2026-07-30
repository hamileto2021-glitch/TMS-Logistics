import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  static const String _tokenKey = 'auth_token';
  final _secureStorage = const FlutterSecureStorage();

  factory TokenStorage() {
    return _instance;
  }

  TokenStorage._internal();

  Future<void> saveToken(String token) async {
    try {
      final normalizedToken = token.trim();
      await _secureStorage.write(key: _tokenKey, value: normalizedToken);
      print("[STORAGE] ✅ Token saved successfully");
      print("[STORAGE] Token length: ${normalizedToken.length}");
    } catch (e) {
      print("[STORAGE] ❌ Error saving token: $e");
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null) {
        print("[STORAGE] ✅ Token retrieved: ${token.substring(0, 20)}...");
      } else {
        print("[STORAGE] ⚠️ No token in storage");
      }
      return token;
    } catch (e) {
      print("[STORAGE] ❌ Error retrieving token: $e");
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      print("[STORAGE] ✅ Token cleared");
    } catch (e) {
      print("[STORAGE] ❌ Error clearing token: $e");
    }
  }
}
