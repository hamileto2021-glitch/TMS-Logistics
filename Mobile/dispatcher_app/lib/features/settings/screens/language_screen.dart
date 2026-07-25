import 'package:flutter/material.dart';

import '../../../core/localization/locale_service.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final LocaleService _localeService = LocaleService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language"),
      ),
      body: AnimatedBuilder(
        animation: _localeService,
        builder: (context, _) {
          return ListView(
            children: [
              RadioListTile<String>(
                value: "en",
                groupValue: _localeService.locale.languageCode,
                title: const Text("English"),
                secondary: const Text("🇺🇸", style: TextStyle(fontSize: 22)),
                onChanged: (value) {
                  if (value != null) {
                    _localeService.setLocale(Locale(value));
                  }
                },
              ),
              RadioListTile<String>(
                value: "om",
                groupValue: _localeService.locale.languageCode,
                title: const Text("Afaan Oromo"),
                secondary: const Text("🇪🇹", style: TextStyle(fontSize: 22)),
                onChanged: (value) {
                  if (value != null) {
                    _localeService.setLocale(Locale(value));
                  }
                },
              ),
              RadioListTile<String>(
                value: "am",
                groupValue: _localeService.locale.languageCode,
                title: const Text("አማርኛ"),
                secondary: const Text("🇪🇹", style: TextStyle(fontSize: 22)),
                onChanged: (value) {
                  if (value != null) {
                    _localeService.setLocale(Locale(value));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}