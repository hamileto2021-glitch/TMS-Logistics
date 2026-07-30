import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenKey = "jwt_token";
  static const _nameKey = "driver_name";
  static const _emailKey = "driver_email";
  static const _roleKey = "driver_role";
  static const _driverIdKey = "driver_id";
  static const _vehicleIdKey = "vehicle_id";

  Future<void> saveUser({
    required String token,
    required String name,
    required String email,
    required String role,
    int? driverId,
    int? vehicleId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_roleKey, role);

    if (driverId != null) {
      await prefs.setInt(_driverIdKey, driverId);
    }

    if (vehicleId != null) {
      await prefs.setInt(_vehicleIdKey, vehicleId);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getDriverName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<int?> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_driverIdKey);
  }

  Future<int?> getVehicleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_vehicleIdKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}