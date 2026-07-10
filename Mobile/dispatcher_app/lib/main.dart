import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/storage/token_storage.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/tracking/screens/live_tracking_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final token = await tokenStorage.getToken();

  runApp(TmsApp(isLoggedIn: token != null));
}

class TmsApp extends StatelessWidget {
  final bool isLoggedIn;

  const TmsApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dispatcher App',
      theme: AppTheme.lightTheme,
      home: isLoggedIn
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}
