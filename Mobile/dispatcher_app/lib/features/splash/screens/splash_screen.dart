import 'package:flutter/material.dart';

import '../../../core/services/auth_manager.dart';
import '../../auth/login_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../../core/storage/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthManager _authManager = AuthManager.instance;

  @override
  void initState() {
    super.initState();
    _startup();
  }

  Future<void> _startup() async {
    await Future.delayed(const Duration(seconds: 2));

    final loggedIn = await _authManager.isLoggedIn();

    if (!mounted) return;

    if (!loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.local_shipping,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              "TMS Logistics",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}