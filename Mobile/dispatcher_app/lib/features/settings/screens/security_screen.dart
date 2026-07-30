import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispatcher_app/l10n/app_localizations.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool biometricLogin = false;
  bool pinLock = false;
  bool autoLogout = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      biometricLogin = prefs.getBool("biometricLogin") ?? false;
      pinLock = prefs.getBool("pinLock") ?? false;
      autoLogout = prefs.getBool("autoLogout") ?? true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.security),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text("Biometric Login"),
            subtitle: const Text("Use fingerprint or face recognition"),
            value: biometricLogin,
            onChanged: (value) {
              setState(() => biometricLogin = value);
              _save("biometricLogin", value);
            },
          ),

          const Divider(),

          SwitchListTile(
            secondary: const Icon(Icons.pin),
            title: const Text("PIN Lock"),
            subtitle: const Text("Require a PIN when opening the app"),
            value: pinLock,
            onChanged: (value) {
              setState(() => pinLock = value);
              _save("pinLock", value);
            },
          ),

          const Divider(),

          SwitchListTile(
            secondary: const Icon(Icons.timer),
            title: const Text("Auto Logout"),
            subtitle: const Text("Automatically log out after inactivity"),
            value: autoLogout,
            onChanged: (value) {
              setState(() => autoLogout = value);
              _save("autoLogout", value);
            },
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.phone_android),
            title: Text("Current Device"),
            subtitle: Text("This device"),
          ),
        ],
      ),
    );
  }
}