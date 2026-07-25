import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  LocaleService._() {
    loadLocale();
  }

  static final LocaleService instance = LocaleService._();

  static const String _key = "app_locale";

  Locale _locale = const Locale("en");

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final code = prefs.getString(_key) ?? "en";

    _locale = Locale(code);

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, locale.languageCode);

    notifyListeners();
  }
}