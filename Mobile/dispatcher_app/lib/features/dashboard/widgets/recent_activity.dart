import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Recent Activities",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 16),

            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: Text("Shipment Created"),
              subtitle: Text("SHP-000021"),
            ),

            ListTile(
              leading: Icon(
                Icons.local_shipping,
                color: Colors.orange,
              ),
              title: Text("Dispatch Started"),
              subtitle: Text("DSP-000005"),
            ),

            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text("Driver Assigned"),
              subtitle: Text("Mohammed"),
            ),
          ],
        ),
      ),
    );
  }
}