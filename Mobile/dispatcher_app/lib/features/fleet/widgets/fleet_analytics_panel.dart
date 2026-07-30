import 'package:flutter/material.dart';

import '../models/fleet_analytics.dart';

class FleetAnalyticsPanel extends StatelessWidget {
  final FleetAnalytics? analytics;

  const FleetAnalyticsPanel({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    if (analytics == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final items = [
      (
      "Moving",
      analytics!.movingVehicles.toString(),
      Icons.local_shipping,
      Colors.green,
      ),
      (
      "Idle",
      analytics!.idleVehicles.toString(),
      Icons.pause_circle,
      Colors.orange,
      ),
      (
      "Offline",
      analytics!.offlineVehicles.toString(),
      Icons.portable_wifi_off,
      Colors.red,
      ),
      (
      "Avg Speed",
      "${analytics!.averageSpeed.toStringAsFixed(1)} km/h",
      Icons.speed,
      Colors.blue,
      ),
      (
      "Alerts",
      analytics!.alertsToday.toString(),
      Icons.warning,
      Colors.deepOrange,
      ),
      (
      "Distance",
      "${analytics!.totalDistanceToday.toStringAsFixed(1)} km",
      Icons.route,
      Colors.purple,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (_, index) {
          final item = items[index];

          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: item.$4.withOpacity(.15),
                    child: Icon(
                      item.$3,
                      color: item.$4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}