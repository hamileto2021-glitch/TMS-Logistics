import 'package:flutter/material.dart';

import '../../../core/services/dashboard_service.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../models/dashboard_summary.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/overview_cards.dart';
import '../widgets/quick_actions.dart';
import '../widgets/fleet_status_card.dart';
import '../widgets/shipment_status_card.dart';
import '../widgets/recent_activity.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();

  late Future<DashboardSummary> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _dashboardService.getSummary();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardFuture = _dashboardService.getSummary();
    });

    await _dashboardFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("TMS Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDashboard,
          ),
        ],
      ),

      body: FutureBuilder<DashboardSummary>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("No dashboard data available."),
            );
          }

          final summary = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshDashboard,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                const DashboardHeader(),

                const SizedBox(height: 20),

                OverviewCards(
                  summary: summary,
                ),

                const SizedBox(height: 20),

                const QuickActions(),

                const SizedBox(height: 20),

                FleetStatusCard(
                  available: summary.availableVehicles,
                  assigned: 0,
                  maintenance: 0,
                ),

                const SizedBox(height: 20),

                ShipmentStatusCard(
                  pending: summary.pendingShipments,
                  dispatched: summary.activeDispatches,
                  delivered: 0,
                ),

                const SizedBox(height: 20),

                const RecentActivity(),

                const SizedBox(height: 30),

              ],
            ),
          );
        },
      ),
    );
  }
}