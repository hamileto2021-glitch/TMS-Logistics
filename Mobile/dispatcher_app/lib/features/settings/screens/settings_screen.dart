import 'package:flutter/material.dart';
import 'package:dispatcher_app/l10n/app_localizations.dart';

import '../../../core/localization/locale_service.dart';
import 'change_password_screen.dart';
import 'language_screen.dart';
import 'profile_screen.dart';
import 'theme_screen.dart';
import 'notification_settings_screen.dart';
import 'synchronization_screen.dart';
import 'security_screen.dart';
import 'about_screen.dart';
import '../../../core/services/auth_manager.dart';
import '../../auth/login_screen.dart';



class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.profile),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Change Password
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(l10n.changePassword),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Appearance
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(l10n.appearance),
            subtitle: Text(
              "${l10n.light} / ${l10n.dark} / ${l10n.system}",
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ThemeScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(
              LocaleService.instance.locale.languageCode == "en"
                  ? "English"
                  : LocaleService.instance.locale.languageCode == "om"
                  ? "Afaan Oromo"
                  : "አማርኛ",
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguageScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Synchronization
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(l10n.synchronization),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SynchronizationScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Security
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(l10n.security),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SecurityScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.about),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final logout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.logout),
                  content: const Text(
                    "Are you sure you want to logout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (logout == true) {
                await AuthManager.instance.logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}