import 'package:flutter/material.dart';

import '../models/report_summary.dart';
import '../services/report_service.dart';

class FleetReportScreen extends StatefulWidget {
  const FleetReportScreen({super.key});

  @override
  State<FleetReportScreen> createState() => _FleetReportScreenState();
}

class _FleetReportScreenState extends State<FleetReportScreen> {
  final ReportService _service = ReportService();

  late Future<ReportSummary> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getSummary();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getSummary();
    });

    await _future;
  }

  Widget buildCard(
      String title,
      int value,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fleet Report"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<ReportSummary>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final report = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [

                buildCard(
                  "Total Vehicles",
                  report.totalVehicles,
                  Icons.local_shipping,
                  Colors.blue,
                ),

                buildCard(
                  "Available Vehicles",
                  report.availableVehicles,
                  Icons.check_circle,
                  Colors.green,
                ),

                buildCard(
                  "Busy Vehicles",
                  report.busyVehicles,
                  Icons.directions_car,
                  Colors.orange,
                ),

                buildCard(
                  "Maintenance",
                  report.maintenanceVehicles,
                  Icons.build,
                  Colors.red,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}