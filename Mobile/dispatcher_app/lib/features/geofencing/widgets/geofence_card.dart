import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/geofence_controller.dart';
import '../models/geofence.dart';
import '../screens/geofence_form_screen.dart';

class GeofenceCard extends StatelessWidget {
  final Geofence geofence;

  const GeofenceCard({
    super.key,
    required this.geofence,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: const Icon(Icons.location_on),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    geofence.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    geofence.isActive ? "Active" : "Inactive",
                  ),
                  backgroundColor: geofence.isActive
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildInfoRow(
              Icons.category,
              "Type",
              geofence.type,
            ),

            _buildInfoRow(
              Icons.radio_button_checked,
              "Radius",
              "${geofence.radius.toStringAsFixed(0)} m",
            ),

            _buildInfoRow(
              Icons.pin_drop,
              "Latitude",
              geofence.latitude.toStringAsFixed(6),
            ),

            _buildInfoRow(
              Icons.place,
              "Longitude",
              geofence.longitude.toStringAsFixed(6),
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GeofenceFormScreen(
                          geofence: geofence,
                        ),
                      ),
                    );

                    if (!context.mounted) return;

                    context.read<GeofenceController>().refresh();
                  },
                ),

                const SizedBox(width: 12),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Delete Geofence"),
                        content: Text(
                          'Delete "${geofence.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      await context
                          .read<GeofenceController>()
                          .delete(geofence.id);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}