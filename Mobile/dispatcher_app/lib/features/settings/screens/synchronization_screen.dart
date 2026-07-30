import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispatcher_app/l10n/app_localizations.dart';

class SynchronizationScreen extends StatefulWidget {
  const SynchronizationScreen({super.key});

  @override
  State<SynchronizationScreen> createState() =>
      _SynchronizationScreenState();
}

class _SynchronizationScreenState
    extends State<SynchronizationScreen> {
  bool autoSync = true;
  bool wifiOnly = false;
  bool backgroundSync = true;

  String lastSync = "Never";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      autoSync = prefs.getBool("autoSync") ?? true;
      wifiOnly = prefs.getBool("wifiOnly") ?? false;
      backgroundSync = prefs.getBool("backgroundSync") ?? true;
      lastSync = prefs.getString("lastSync") ?? "Never";
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _syncNow() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();

    final value =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    await prefs.setString("lastSync", value);

    setState(() {
      lastSync = value;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Synchronization completed."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.synchronization),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text("Last Synchronization"),
            subtitle: Text(lastSync),
          ),

          const Divider(),

          SwitchListTile(
            title: const Text("Auto Synchronization"),
            value: autoSync,
            onChanged: (v) {
              setState(() => autoSync = v);
              _saveBool("autoSync", v);
            },
          ),

          SwitchListTile(
            title: const Text("Wi-Fi Only"),
            value: wifiOnly,
            onChanged: (v) {
              setState(() => wifiOnly = v);
              _saveBool("wifiOnly", v);
            },
          ),

          SwitchListTile(
            title: const Text("Background Synchronization"),
            value: backgroundSync,
            onChanged: (v) {
              setState(() => backgroundSync = v);
              _saveBool("backgroundSync", v);
            },
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _syncNow,
              icon: const Icon(Icons.sync),
              label: const Text("Sync Now"),
            ),
          ),
        ],
      ),
    );
  }
}