import 'package:flutter/material.dart';

import '../../../models/customer.dart';
import 'customer_form_screen.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  Widget _buildTile(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            CircleAvatar(
              radius: 40,
              child: const Icon(
                Icons.business,
                size: 40,
              ),
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  child: const Icon(
                    Icons.business,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  customer.companyName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),

                Text(
                  customer.customerCode,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Call action (next step)
                    },
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Email action (next step)
                    },
                    icon: const Icon(Icons.email),
                    label: const Text("Email"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildTile(
              "Customer Code",
              customer.customerCode,
              Icons.badge,
            ),

            _buildTile(
              "Contact Person",
              customer.contactPerson,
              Icons.person,
            ),

            _buildTile(
              "Phone",
              customer.phone,
              Icons.phone,
            ),

            _buildTile(
              "Email",
              customer.email,
              Icons.email,
            ),

            _buildTile(
              "Address",
              customer.address,
              Icons.location_on,
            ),

            _buildTile(
              "City",
              customer.city,
              Icons.location_city,
            ),

            _buildTile(
              "State",
              customer.state,
              Icons.map,
            ),

            _buildTile(
              "Country",
              customer.country,
              Icons.public,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Customer"),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerFormScreen(
                        customer: customer,
                      ),
                    ),
                  );

                  if (context.mounted && updated == true) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Future Features",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.local_shipping),
                title: const Text("Shipment History"),
                subtitle: const Text("Coming soon"),
                trailing: const Icon(Icons.chevron_right),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}