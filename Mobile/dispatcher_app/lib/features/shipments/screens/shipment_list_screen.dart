import 'package:flutter/material.dart';

import '../../../core/services/shipment_service.dart';

import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../core/widgets/confirm_delete_dialog.dart';
import '../../../core/widgets/dashboard_stat_card.dart';

import '../../../models/shipment.dart';

import 'shipment_form_screen.dart';
import 'shipment_details_screen.dart';
import 'shipment_list_screen.dart';
import '../widgets/shipment_statistics.dart';

class ShipmentListScreen extends StatefulWidget {
  const ShipmentListScreen({super.key});

  @override
  State<ShipmentListScreen> createState() =>
      _ShipmentListScreenState();
}

class _ShipmentListScreenState
    extends State<ShipmentListScreen> {

final ShipmentService _service =
ShipmentService();

late Future<List<Shipment>> _shipments;

final TextEditingController _searchController =
TextEditingController();

String _searchText = "";

@override
void initState() {
super.initState();
_loadShipments();
}

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

void _loadShipments() {
_shipments = _service.getShipments();
}

Future<void> _refresh() async {
setState(() {
_loadShipments();
});
}

Future<void> _deleteShipment(
Shipment shipment) async {

final confirmed =
await ConfirmDeleteDialog.show(
context,
title: "Delete Shipment",
message:
"Delete ${shipment.shipmentNumber} ?",
);

if (!confirmed) return;

try {

await _service.deleteShipment(
shipment.id);

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
backgroundColor: Colors.green,
content: Text(
"${shipment.shipmentNumber} deleted.",
),
),
);

_refresh();

} catch (e) {

ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
backgroundColor: Colors.red,
content: Text(e.toString()),
),
);
}
}

List<Shipment> _filterShipments(
List<Shipment> shipments) {

if (_searchText.isEmpty) {
return shipments;
}

return shipments.where((s) {

final q =
_searchText.toLowerCase();

return
s.shipmentNumber
.toLowerCase()
.contains(q) ||

s.origin
.toLowerCase()
.contains(q) ||

s.destination
.toLowerCase()
.contains(q) ||

s.cargoType
.toLowerCase()
.contains(q);

}).toList();
}
@override
Widget build(BuildContext context) {
return Scaffold(
drawer: const AppDrawer(),

appBar: AppBar(
title: const Text("Shipments"),
centerTitle: true,
),

floatingActionButton: FloatingActionButton.extended(
icon: const Icon(Icons.add),
label: const Text("Shipment"),
onPressed: () async {
await Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const ShipmentFormScreen(),
),
);

_refresh();
},
),

body: Column(
children: [

AppSearchBar(
controller: _searchController,
hintText: "Search shipment...",
onChanged: (value) {
setState(() {
_searchText = value;
});
},
),

Expanded(
child: FutureBuilder<List<Shipment>>(
future: _shipments,
builder: (context, snapshot) {

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const AppLoading(
message: "Loading shipments...",
);
}

if (snapshot.hasError) {
return Center(
child: Padding(
padding: const EdgeInsets.all(20),
child: Text(
snapshot.error.toString(),
textAlign: TextAlign.center,
),
),
);
}

if (!snapshot.hasData) {
return const AppEmptyState(
icon: Icons.inventory,
title: "No Shipments",
subtitle: "Shipment list is empty.",
);
}

final shipments =
_filterShipments(snapshot.data!);

final total = shipments.length;

final pending = shipments
.where((s) => s.status == "Pending")
.length;

final dispatched = shipments
.where((s) => s.status == "Dispatched")
.length;

final delivered = shipments
.where((s) => s.status == "Delivered")
.length;

if (shipments.isEmpty) {
return const AppEmptyState(
icon: Icons.search_off,
title: "No Results",
subtitle:
"No shipment matches your search.",
);
}

return Column(
children: [

Padding(
padding: const EdgeInsets.all(12),
child: GridView.count(
crossAxisCount: 2,
shrinkWrap: true,
physics:
const NeverScrollableScrollPhysics(),
crossAxisSpacing: 12,
mainAxisSpacing: 12,
childAspectRatio: 1.8,
children: [

DashboardStatCard(
title: "Total",
value: total.toString(),
icon: Icons.inventory,
color: Colors.blue,
),

DashboardStatCard(
title: "Pending",
value: pending.toString(),
icon: Icons.pending,
color: Colors.orange,
),

DashboardStatCard(
title: "Dispatched",
value: dispatched.toString(),
icon: Icons.local_shipping,
color: Colors.indigo,
),

DashboardStatCard(
title: "Delivered",
value: delivered.toString(),
icon: Icons.check_circle,
color: Colors.green,
),
],
),
),

Expanded(
child: RefreshIndicator(
onRefresh: _refresh,

child: ListView.builder(
padding:
const EdgeInsets.only(bottom: 80),

itemCount: shipments.length,

itemBuilder: (context, index) {

final shipment =
shipments[index];

return Card(
margin: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 6,
),
elevation: 2,
child: ListTile(
contentPadding:
const EdgeInsets.symmetric(
horizontal: 16,
vertical: 10,
),

onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
ShipmentDetailsScreen(
shipment: shipment,
),
),
);
},

leading: CircleAvatar(
radius: 28,
backgroundColor:
Colors.orange.shade100,
child: const Icon(
Icons.inventory,
color: Colors.orange,
size: 30,
),
),

title: Text(
shipment.shipmentNumber,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 17,
),
),

subtitle: Padding(
padding:
const EdgeInsets.only(top: 8),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Text(
"${shipment.origin} → ${shipment.destination}",
style: const TextStyle(
fontWeight:
FontWeight.w600,
),
),

const SizedBox(height: 4),

Text(
shipment.cargoType,
),

Text(
"Weight: ${shipment.weight} Kg",
),

const SizedBox(height: 8),

AppStatusChip(
status: shipment.status,
),
],
),
),

trailing:
PopupMenuButton<String>(
onSelected: (value) async {
switch (value) {

case "details":
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
ShipmentDetailsScreen(
shipment: shipment,
),
),
);
break;

case "edit":
await Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
ShipmentFormScreen(
shipment: shipment,
),
),
);

_refresh();
break;

case "delete":
await _deleteShipment(
shipment,
);
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
},
),
),
),
],
);
},
),
),
],
),
);
}
}