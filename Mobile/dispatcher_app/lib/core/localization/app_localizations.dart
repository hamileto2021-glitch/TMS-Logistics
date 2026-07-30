import 'package:flutter/material.dart';

import 'am.dart';
import 'en.dart';
import 'om.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(
      Localizations.localeOf(context),
    );
  }

  String text(String key) {
    switch (locale.languageCode) {
      case "om":
        return om[key] ?? key;

      case "am":
        return am[key] ?? key;

      default:
        return en[key] ?? key;
    }
  }
}