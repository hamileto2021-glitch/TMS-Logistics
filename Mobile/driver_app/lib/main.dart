import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/tracking/trip_tracking_manager.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<TripTrackingManager>(
          create: (_) => TripTrackingManager(),
        ),
      ],
      child: const DriverApp(),
    ),
  );
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TMS Driver',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}