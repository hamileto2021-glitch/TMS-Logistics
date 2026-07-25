
import 'package:flutter/material.dart';

import '../../../models/shipment.dart';

class ShipmentDetailsScreen extends StatelessWidget {
final Shipment shipment;

const ShipmentDetailsScreen({
super.key,
required this.shipment,
});

Color get statusColor {
switch (shipment.status) {
case "Pending":
return Colors.orange;

case "Dispatched":
return Colors.blue;

case "In Transit":
return Colors.deepPurple;

case "Delivered":
return Colors.green;

case "Cancelled":
return Colors.red;

default:
return Colors.grey;
}
}

String formatDate(DateTime? date) {
if (date == null) return "-";

return "${date.day.toString().padLeft(2, '0')}/"
"${date.month.toString().padLeft(2, '0')}/"
"${date.year}";
}

Widget sectionTitle(
IconData icon,
String title,
) {
return Row(
children: [
Icon(
icon,
color: Colors.blue,
),
const SizedBox(width: 10),
Text(
title,
style: const TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
),
),
],
);
}

Widget infoTile({
required IconData icon,
required String title,
required String value,
}) {
return Card(
elevation: 1,
margin: const EdgeInsets.symmetric(vertical: 6),
child: ListTile(
leading: CircleAvatar(
backgroundColor: Colors.blue.shade50,
child: Icon(
icon,
color: Colors.blue,
),
),
title: Text(title),
subtitle: Text(
value.isEmpty ? "-" : value,
style: const TextStyle(
fontWeight: FontWeight.w600,
),
),
),
);
}

Widget infoBox({
required String title,
required String value,
required IconData icon,
}) {
return Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: Colors.grey.shade100,
borderRadius: BorderRadius.circular(14),
),
child: Column(
children: [
Icon(
icon,
color: Colors.blue,
size: 30,
),
const SizedBox(height: 8),
Text(
title,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
Text(
value,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 15,
),
),
],
),
);
}

Widget shipmentHeader() {
return Card(
elevation: 3,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(22),
child: Column(
children: [
CircleAvatar(
radius: 42,
backgroundColor: Colors.orange.shade100,
child: const Icon(
Icons.local_shipping,
color: Colors.orange,
size: 42,
),
),
const SizedBox(height: 18),
Text(
shipment.shipmentNumber,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
Chip(
backgroundColor: statusColor,
label: Text(
shipment.status,
style: const TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
),
],
),
),
);
}

Widget assignmentCard() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
sectionTitle(
Icons.people,
"Assignments",
),
const SizedBox(height: 18),
infoTile(
icon: Icons.business,
title: "Customer",
value: shipment.customerName ?? "Not Assigned",
),
infoTile(
icon: Icons.local_shipping,
title: "Vehicle",
value: shipment.vehiclePlateNumber == null
? "Not Assigned"
: "${shipment.vehiclePlateNumber}\n${shipment.vehicleName ?? ""}",
),
infoTile(
icon: Icons.badge,
title: "Driver",
value: shipment.driverName == null
? "Not Assigned"
: "${shipment.driverName}\n${shipment.driverPhone ?? ""}",
),
],
),
),
);
}
// shipment_details_screen.dart
// =========================
// Chunk 2 / 4

Widget routeCard() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
sectionTitle(
Icons.route,
"Route",
),

const SizedBox(height: 20),

Row(
children: [
CircleAvatar(
radius: 18,
backgroundColor: Colors.green.shade100,
child: const Icon(
Icons.location_on,
color: Colors.green,
),
),

const SizedBox(width: 12),

Expanded(
child: Text(
shipment.origin,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
),
],
),

const Padding(
padding: EdgeInsets.only(left: 17),
child: SizedBox(
height: 40,
child: VerticalDivider(
thickness: 2,
),
),
),

Row(
children: [
CircleAvatar(
radius: 18,
backgroundColor: Colors.red.shade100,
child: const Icon(
Icons.flag,
color: Colors.red,
),
),

const SizedBox(width: 12),

Expanded(
child: Text(
shipment.destination,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
),
],
),
],
),
),
);
}

Widget cargoCard() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
sectionTitle(
Icons.inventory_2,
"Cargo Information",
),

const SizedBox(height: 18),

Row(
children: [
Expanded(
child: infoBox(
title: "Cargo",
value: shipment.cargoType,
icon: Icons.inventory,
),
),

const SizedBox(width: 12),

Expanded(
child: infoBox(
title: "Weight",
value: "${shipment.weight} Kg",
icon: Icons.scale,
),
),
],
),

const SizedBox(height: 12),

Row(
children: [
Expanded(
child: infoBox(
title: "Volume",
value: "${shipment.volume} m³",
icon: Icons.straighten,
),
),

const SizedBox(width: 12),

Expanded(
child: infoBox(
title: "Packages",
value: shipment.numberOfPackages.toString(),
icon: Icons.all_inbox,
),
),
],
),
],
),
),
);
}

Widget datesCard() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
sectionTitle(
Icons.calendar_month,
"Shipment Dates",
),

const SizedBox(height: 18),

infoTile(
icon: Icons.event,
title: "Booking Date",
value: formatDate(shipment.bookingDate),
),

infoTile(
icon: Icons.local_shipping,
title: "Dispatch Date",
value: formatDate(shipment.dispatchDate),
),

infoTile(
icon: Icons.flag,
title: "Expected Delivery",
value: formatDate(
shipment.expectedDeliveryDate,
),
),
],
),
),
);
}
// shipment_details_screen.dart
// =========================
// Chunk 3 / 4

Widget timelineItem({
required String title,
required bool completed,
required Color color,
}) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 8),
child: Row(
children: [
Icon(
completed
? Icons.check_circle
: Icons.radio_button_unchecked,
color: completed ? color : Colors.grey,
size: 28,
),

const SizedBox(width: 14),

Expanded(
child: Text(
title,
style: TextStyle(
fontSize: 16,
fontWeight: completed
? FontWeight.bold
: FontWeight.normal,
),
),
),
],
),
);
}

Widget timelineCard() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
sectionTitle(
Icons.timeline,
"Shipment Progress",
),

const SizedBox(height: 16),

timelineItem(
title: "Pending",
completed: true,
color: Colors.orange,
),

timelineItem(
title: "Dispatched",
completed: shipment.status != "Pending",
color: Colors.blue,
),

timelineItem(
title: "In Transit",
completed: shipment.status == "In Transit" ||
shipment.status == "Delivered",
color: Colors.deepPurple,
),

timelineItem(
title: "Delivered",
completed: shipment.status == "Delivered",
color: Colors.green,
),
],
),
),
);
}

Widget notesCard() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
sectionTitle(
Icons.notes,
"Notes",
),

const SizedBox(height: 16),

Text(
shipment.notes.isEmpty
? "No notes available."
: shipment.notes,
style: const TextStyle(
fontSize: 15,
height: 1.5,
),
),
],
),
),
);
}

Widget actionButtons(BuildContext context) {
return Column(
children: [
Row(
children: [
Expanded(
child: ElevatedButton.icon(
icon: const Icon(Icons.edit),
label: const Text("Edit"),
onPressed: () {
// TODO: Navigate to ShipmentFormScreen
},
),
),

const SizedBox(width: 12),

Expanded(
child: ElevatedButton.icon(
icon: const Icon(Icons.local_shipping),
label: const Text("Dispatch"),
onPressed: () {
// TODO: Call Dispatch API
},
),
),
],
),

const SizedBox(height: 12),

Row(
children: [
Expanded(
child: FilledButton.icon(
icon: const Icon(Icons.check_circle),
label: const Text("Complete"),
onPressed: () {
// TODO: Call Complete API
},
),
),

const SizedBox(width: 12),

Expanded(
child: FilledButton.tonalIcon(
icon: const Icon(Icons.delete),
label: const Text("Delete"),
onPressed: () async {
final confirmed =
await showDialog<bool>(
context: context,
builder: (_) => AlertDialog(
title: const Text(
"Delete Shipment",
),
content: Text(
"Delete ${shipment.shipmentNumber}?",
),
actions: [
TextButton(
onPressed: () =>
Navigator.pop(
context,
false,
),
child: const Text(
"Cancel",
),
),
FilledButton(
onPressed: () =>
Navigator.pop(
context,
true,
),
child: const Text(
"Delete",
),
),
],
),
) ??
false;

if (!confirmed) return;

// TODO: Call Delete API
},
),
),
],
),
],
);
}
// shipment_details_screen.dart
// =========================
// Chunk 4 / 4

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Shipment Details",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            shipmentHeader(),

            const SizedBox(height: 16),

            // Customer / Vehicle / Driver
            assignmentCard(),

            const SizedBox(height: 16),

            // Route
            routeCard(),

            const SizedBox(height: 16),

            // Cargo
            cargoCard(),

            const SizedBox(height: 16),

            // Dates
            datesCard(),

            const SizedBox(height: 16),

            // Timeline
            timelineCard(),

            const SizedBox(height: 16),

            // Notes
            notesCard(),

            const SizedBox(height: 24),

            // Action Buttons
            actionButtons(context),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}