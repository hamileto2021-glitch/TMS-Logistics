import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';
import '../../trips/screens/my_trips_screen.dart';
import '../../../core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  final TokenStorage _storage = TokenStorage();
  final LocationService _locationService = LocationService();

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
  Future<void> _testGps() async {
    final granted = await _locationService.requestPermission();

    if (!granted) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission denied."),
        ),
      );

      return;
    }

    Position position =
    await _locationService.getCurrentLocation();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Current GPS"),

        content: Text(
          "Latitude : ${position.latitude}\n\n"
              "Longitude : ${position.longitude}",
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyTripsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.route),
              label: const Text(
                "MY TRIPS",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _testGps,
              icon: const Icon(Icons.location_on),
              label: const Text(
                "TEST GPS",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
