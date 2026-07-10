import 'package:flutter/material.dart';

class ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class DashboardRecentActivity extends StatelessWidget {
  final List<ActivityItem> activities;

  const DashboardRecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            if (activities.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text("No recent activities.")),
              )
            else
              ...activities.map(
                (activity) => Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: CircleAvatar(
                        backgroundColor: activity.color.withValues(alpha: .15),

                        child: Icon(activity.icon, color: activity.color),
                      ),

                      title: Text(activity.title),

                      subtitle: Text(activity.subtitle),
                    ),

                    const Divider(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
