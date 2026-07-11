import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage Keys
  static const String _tokenKey = "jwt_token";
  static const String _nameKey = "driver_name";
  static const String _driverIdKey = "driver_id";
  static const String _vehicleIdKey = "vehicle_id";
  static const String _roleKey = "role";
  static const String _emailKey = "email";

  /// Save only JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  /// Save logged-in user information
  Future<void> saveUser({
    required String token,
    required String name,
    required String email,
    required String role,
    required int? driverId,
    required int? vehicleId,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _nameKey, value: name);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _roleKey, value: role);

    await _storage.write(
      key: _driverIdKey,
      value: (driverId ?? 0).toString(),
    );

    await _storage.write(
      key: _vehicleIdKey,
      value: (vehicleId ?? 0).toString(),
    );
  }

  /// Read values
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getDriverName() async {
    return await _storage.read(key: _nameKey);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: _roleKey);
  }

  Future<int?> getDriverId() async {
    final value = await _storage.read(key: _driverIdKey);

    if (value == null) return null;

    return int.tryParse(value);
  }

  Future<int?> getVehicleId() async {
    final value = await _storage.read(key: _vehicleIdKey);

    if (value == null) return null;

    return int.tryParse(value);
  }

  /// Generic read method
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Check login status
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}