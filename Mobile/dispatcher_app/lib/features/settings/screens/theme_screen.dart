import 'package:flutter/material.dart';

import '../../../core/theme/theme_service.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final ThemeService _themeService = ThemeService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme"),
      ),
      body: AnimatedBuilder(
        animation: _themeService,
        builder: (context, _) {
          return ListView(
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: _themeService.themeMode,
                title: const Text("System Default"),
                secondary: const Icon(Icons.phone_android),
                onChanged: (value) {
                  if (value != null) {
                    _themeService.setTheme(value);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: _themeService.themeMode,
                title: const Text("Light"),
                secondary: const Icon(Icons.light_mode),
                onChanged: (value) {
                  if (value != null) {
                    _themeService.setTheme(value);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: _themeService.themeMode,
                title: const Text("Dark"),
                secondary: const Icon(Icons.dark_mode),
                onChanged: (value) {
                  if (value != null) {
                    _themeService.setTheme(value);
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