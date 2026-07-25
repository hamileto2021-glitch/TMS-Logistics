import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/current_user.dart';

class UserStorage {
  static const _key = "current_user";

  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  Future<void> save(CurrentUser user) async {
    await _storage.write(
      key: _key,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<CurrentUser?> get() async {
    final json = await _storage.read(key: _key);

    if (json == null) return null;

    return CurrentUser.fromJson(
      jsonDecode(json),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}