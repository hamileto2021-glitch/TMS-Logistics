import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const TmsApp());
}

class TmsApp extends StatelessWidget {
  const TmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TMS Logistics',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
