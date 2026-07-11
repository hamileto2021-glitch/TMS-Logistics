import 'package:flutter/material.dart';

import '../../core/storage/token_storage.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  final TokenStorage _storage = TokenStorage();

  String _name = "";
  String _email = "";
  String _role = "";
  int? _driverId;
  int? _vehicleId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    _name = await _storage.getDriverName() ?? "";
    _email = await _storage.getEmail() ?? "";
    _role = await _storage.getRole() ?? "";

    _driverId = await _storage.getDriverId();
    _vehicleId = await _storage.getVehicleId();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _logout() async {
    await _storage.clear();

    if (!mounted) return;

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget buildCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const SizedBox(height: 10),

          Center(
            child: CircleAvatar(
              radius: 45,
              child: Text(
                _name.isEmpty ? "D" : _name[0].toUpperCase(),
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              _name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          Center(
            child: Text(_email, style: const TextStyle(color: Colors.grey)),
          ),

          const SizedBox(height: 25),

          buildCard("Role", _role, Icons.badge, Colors.blue),

          buildCard(
            "Driver ID",
            "${_driverId ?? 0}",
            Icons.person,
            Colors.green,
          ),

          buildCard(
            "Vehicle ID",
            "${_vehicleId ?? 0}",
            Icons.local_shipping,
            Colors.orange,
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                // Next:
                // Open My Trips
              },
              icon: const Icon(Icons.route),
              label: const Text("MY TRIPS", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
