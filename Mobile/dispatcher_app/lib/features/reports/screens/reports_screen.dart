import 'package:dispatcher_app/features/reports/screens/shipment_report_screen.dart';
import 'package:dispatcher_app/features/reports/screens/trip_report_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/report_card.dart';
import 'dispatch_report_screen.dart';
import 'driver_report_screen.dart';
import 'fleet_report_screen.dart';
import 'executive_report_screen.dart';



class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Analytics"),
      ),
      body: ListView(
        children: [

          const SizedBox(height: 15),

          ReportCard(
            icon: Icons.analytics,
            title: "Executive Dashboard",
            subtitle: "Overall business KPIs and analytics",
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExecutiveReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            icon: Icons.local_shipping,
            title: "Fleet Report",
            subtitle: "Fleet utilization and vehicle status",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FleetReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            icon: Icons.person,
            title: "Driver Performance",
            subtitle: "Driver productivity and trips",
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DriverReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            icon: Icons.inventory_2,
            title: "Shipment Report",
            subtitle: "Shipment statistics",
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShipmentReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            icon: Icons.assignment,
            title: "Dispatch Report",
            subtitle: "Dispatch operations",
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DispatchReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            icon: Icons.route,
            title: "Trip Report",
            subtitle: "Trip analysis",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TripReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}