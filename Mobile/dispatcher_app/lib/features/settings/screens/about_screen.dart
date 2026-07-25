import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dispatcher_app/l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          const Icon(
            Icons.local_shipping,
            size: 80,
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              "TMS Logistics",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Version"),
            subtitle: Text(version),
          ),

          ListTile(
            leading: const Icon(Icons.build),
            title: const Text("Build"),
            subtitle: Text(buildNumber),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.business),
            title: Text("Company"),
            subtitle: Text("TMS Logistics"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.email),
            title: Text("Support"),
            subtitle: Text("support@tmslogistics.com"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.description),
            title: Text("Privacy Policy"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.gavel),
            title: Text("Terms & Conditions"),
          ),
        ],
      ),
    );
  }
}