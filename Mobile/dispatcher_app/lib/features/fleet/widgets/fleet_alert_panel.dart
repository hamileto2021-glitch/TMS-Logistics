import 'package:flutter/material.dart';

import '../models/fleet_alert.dart';

class FleetAlertPanel extends StatelessWidget {
  final List<FleetAlert> alerts;
  final ValueChanged<FleetAlert>? onAlertTap;

  const FleetAlertPanel({
    super.key,
    required this.alerts,
    this.onAlertTap,
  });

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _alertIcon(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'overspeed':
        return Icons.speed;
      case 'route deviation':
        return Icons.alt_route;
      case 'offline':
        return Icons.wifi_off;
      case 'trip completed':
        return Icons.check_circle;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Live Fleet Alerts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (alerts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No active fleet alerts'),
                ),
              )
            else
              ...alerts.take(5).map(
                    (alert) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: _severityColor(alert.severity).withOpacity(0.08),
                      child: ListTile(
                        onTap: () => onAlertTap?.call(alert),
                    leading: CircleAvatar(
                      backgroundColor:
                      _severityColor(alert.severity),
                      child: Icon(
                        _alertIcon(alert.alertType),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      alert.alertType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(alert.vehiclePlate),
                        Text(alert.message),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          alert.severity,
                          style: TextStyle(
                            color: _severityColor(alert.severity),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}