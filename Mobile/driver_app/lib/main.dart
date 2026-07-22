import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/tracking/services/trip_tracking_manager.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/trips/providers/trip_provider.dart';
import 'features/tracking/providers/tracking_provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          Provider<TripTrackingManager>(
            create: (_) => TripTrackingManager(),
          ),

          ChangeNotifierProvider(
            create: (_) => TripProvider(),
          ),

          ChangeNotifierProvider(
            create: (_) => TrackingProvider(),
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