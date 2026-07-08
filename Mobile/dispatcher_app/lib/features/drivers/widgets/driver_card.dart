import 'package:flutter/material.dart';

import '../../../core/widgets/app_status_chip.dart';
import '../../../models/driver.dart';
import '../driver_details_screen.dart';
import '../driver_form_screen.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;

  const DriverCard({
    super.key,
    required this.driver,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DriverDetailsScreen(
                driver: driver,
              ),
            ),
          );
        },

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green.shade100,
          child: const Icon(
            Icons.person,
            color: Colors.green,
            size: 30,
          ),
        ),

        title: Text(
          driver.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(driver.driverNumber),

              Text(driver.phoneNumber),

              const SizedBox(height: 8),

              AppStatusChip(
                status: driver.status,
              ),
            ],
          ),
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) async {

            switch (value) {

              case "details":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DriverDetailsScreen(
                          driver: driver,
                        ),
                  ),
                );
                break;

              case "edit":
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DriverFormScreen(
                          driver: driver,
                        ),
                  ),
                );

                onRefresh();
                break;

              case "delete":
                onDelete();
                break;
            }
          },

          itemBuilder: (context) => const [

            PopupMenuItem(
              value: "details",
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 10),
                  Text("Details"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 10),
                  Text("Edit"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text("Delete"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}