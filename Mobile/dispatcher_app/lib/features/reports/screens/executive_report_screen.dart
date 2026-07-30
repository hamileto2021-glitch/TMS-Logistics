import 'package:flutter/material.dart';

import '../models/report_summary.dart';
import '../services/report_service.dart';
import '../widgets/kpi_card.dart';
import '../widgets/fleet_pie_chart.dart';
import '../widgets/shipment_bar_chart.dart';
import '../widgets/trip_bar_chart.dart';
import '../widgets/report_filter_bar.dart';
import '../services/pdf_report_service.dart';



class ExecutiveReportScreen extends StatefulWidget {
  const ExecutiveReportScreen({super.key});

  @override
  State<ExecutiveReportScreen> createState() =>
      _ExecutiveReportScreenState();
}

class _ExecutiveReportScreenState
    extends State<ExecutiveReportScreen> {
  final ReportService _service = ReportService();
  final PdfReportService _pdfService =
  PdfReportService();

  late Future<ReportSummary> _future;

  String _period = "This Month";

  @override
  void initState() {
    super.initState();
    _future = _service.getSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Executive Dashboard"),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _future = _service.getSummary();
              });
            },
          ),
        ],
      ),

      body: FutureBuilder<ReportSummary>(
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

              ReportFilterBar(
                selectedPeriod: _period,
                onChanged: (value) {
                  setState(() {
                    _period = value;
                  });

                  // Later this will call the API
                },
              ),

              const SizedBox(height: 20),


              Row(
                children: [
                  KpiCard(
                    title: "Vehicles",
                    value: report.totalVehicles.toString(),
                    icon: Icons.local_shipping,
                    color: Colors.blue,
                  ),

                  const SizedBox(width: 12),

                  KpiCard(
                    title: "Drivers",
                    value: report.totalDrivers.toString(),
                    icon: Icons.person,
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  KpiCard(
                    title: "Shipments",
                    value: report.totalShipments.toString(),
                    icon: Icons.inventory_2,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 12),

                  KpiCard(
                    title: "Trips",
                    value: report.totalTrips.toString(),
                    icon: Icons.route,
                    color: Colors.red,
                  ),
                ],
              ),

              FleetPieChart(
                available: report.availableVehicles,
                busy: report.busyVehicles,
                maintenance: report.maintenanceVehicles,
              ),

              const SizedBox(height: 20),

              ShipmentBarChart(
                delivered: report.deliveredShipments,
                pending: report.pendingShipments,
              ),

              const SizedBox(height: 20),

              TripBarChart(
                completed: report.completedTrips,
                active: report.activeTrips,
              ),

              const SizedBox(height: 20),

              SummaryCard(
                title: "Fleet Summary",
                icon: Icons.local_shipping,
                color: Colors.blue,
                values: {
                  "Total Vehicles": report.totalVehicles,
                  "Available": report.availableVehicles,
                  "Busy": report.busyVehicles,
                  "Maintenance": report.maintenanceVehicles,
                },
              ),

              const SizedBox(height: 16),

              SummaryCard(
                title: "Driver Summary",
                icon: Icons.person,
                color: Colors.green,
                values: {
                  "Total Drivers": report.totalDrivers,
                  "Available": report.availableDrivers,
                  "Assigned": report.assignedDrivers,
                },
              ),

              const SizedBox(height: 16),

              SummaryCard(
                title: "Shipment Summary",
                icon: Icons.inventory_2,
                color: Colors.orange,
                values: {
                  "Total Shipments": report.totalShipments,
                  "Pending": report.pendingShipments,
                  "Delivered": report.deliveredShipments,
                },
              ),

              const SizedBox(height: 16),

              SummaryCard(
                title: "Dispatch Summary",
                icon: Icons.assignment,
                color: Colors.purple,
                values: {
                  "Total Dispatches": report.totalDispatches,
                  "Active Dispatches": report.activeDispatches,
                },
              ),

              const SizedBox(height: 16),

              SummaryCard(
                title: "Trip Summary",
                icon: Icons.route,
                color: Colors.red,
                values: {
                  "Total Trips": report.totalTrips,
                  "Active Trips": report.activeTrips,
                  "Completed Trips": report.completedTrips,
                },
              ),

              Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Export PDF"),
                      onPressed: () async {
                        if (!mounted) return;

                        final report = await _future;

                        await _pdfService.generateExecutiveReport(
                          report,
                          _period,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.table_chart),
                      label: const Text("Export Excel"),
                      onPressed: () {
                        // We'll implement Excel export next
                      },
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Map<String, int> values;

  const SummaryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: [

                Icon(
                  icon,
                  color: color,
                ),

                const SizedBox(width: 10),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const Divider(height: 25),

            ...values.entries.map(
                  (entry) => Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [

                    Text(entry.key),

                    Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}