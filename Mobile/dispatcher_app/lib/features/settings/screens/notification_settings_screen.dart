import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispatcher_app/l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool pushNotifications = true;
  bool tripUpdates = true;
  bool dispatchAlerts = true;
  bool deliveryNotifications = true;
  bool systemAnnouncements = true;
  bool sound = true;
  bool vibration = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      pushNotifications =
          prefs.getBool('pushNotifications') ?? true;
      tripUpdates =
          prefs.getBool('tripUpdates') ?? true;
      dispatchAlerts =
          prefs.getBool('dispatchAlerts') ?? true;
      deliveryNotifications =
          prefs.getBool('deliveryNotifications') ?? true;
      systemAnnouncements =
          prefs.getBool('systemAnnouncements') ?? true;
      sound =
          prefs.getBool('sound') ?? true;
      vibration =
          prefs.getBool('vibration') ?? true;
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
        title: Text(l10n.notifications),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Push Notifications"),
            value: pushNotifications,
            onChanged: (v) {
              setState(() => pushNotifications = v);
              _save("pushNotifications", v);
            },
          ),
          SwitchListTile(
            title: const Text("Trip Updates"),
            value: tripUpdates,
            onChanged: (v) {
              setState(() => tripUpdates = v);
              _save("tripUpdates", v);
            },
          ),
          SwitchListTile(
            title: const Text("Dispatch Alerts"),
            value: dispatchAlerts,
            onChanged: (v) {
              setState(() => dispatchAlerts = v);
              _save("dispatchAlerts", v);
            },
          ),
          SwitchListTile(
            title: const Text("Delivery Notifications"),
            value: deliveryNotifications,
            onChanged: (v) {
              setState(() => deliveryNotifications = v);
              _save("deliveryNotifications", v);
            },
          ),
          SwitchListTile(
            title: const Text("System Announcements"),
            value: systemAnnouncements,
            onChanged: (v) {
              setState(() => systemAnnouncements = v);
              _save("systemAnnouncements", v);
            },
          ),
          SwitchListTile(
            title: const Text("Sound"),
            value: sound,
            onChanged: (v) {
              setState(() => sound = v);
              _save("sound", v);
            },
          ),
          SwitchListTile(
            title: const Text("Vibration"),
            value: vibration,
            onChanged: (v) {
              setState(() => vibration = v);
              _save("vibration", v);
            },
          ),
        ],
      ),
    );
  }
}