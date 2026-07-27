import 'package:flutter/material.dart';

import '../../../core/services/dispatch_service.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../models/dispatch.dart';

import 'dispatch_form_screen.dart';
import 'dispatch_details_screen.dart';

class DispatchListScreen extends StatefulWidget {
  const DispatchListScreen({super.key});

  @override
  State<DispatchListScreen> createState() => _DispatchListScreenState();
}

class _DispatchListScreenState extends State<DispatchListScreen> {
final DispatchService _service = DispatchService();

final TextEditingController _searchController =
TextEditingController();

String _searchText = "";

late Future<List<Dispatch>> _dispatches;

@override
void initState() {
super.initState();
_dispatches = _service.getDispatches();
}

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

Future<void> _refresh() async {
setState(() {
_dispatches = _service.getDispatches();
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Dispatches"),
centerTitle: true,
),

floatingActionButton: FloatingActionButton(
child: const Icon(Icons.add),
onPressed: () async {
final result = await Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const DispatchFormScreen(),
),
);

if (result == true) {
_refresh();
}
},
),

body: FutureBuilder<List<Dispatch>>(
future: _dispatches,
builder: (context, snapshot) {

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(
snapshot.error.toString(),
),
);
}

final dispatches = snapshot.data ?? [];

final filteredDispatches =
dispatches.where((dispatch) {
final search = _searchText.toLowerCase();

return dispatch.dispatchNumber
.toLowerCase()
.contains(search) ||
dispatch.shipmentNumber
.toLowerCase()
.contains(search) ||
dispatch.driverName
.toLowerCase()
.contains(search) ||
dispatch.plateNumber
.toLowerCase()
.contains(search);
}).toList();
if (dispatches.isEmpty) {
return const Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.local_shipping_outlined,
size: 80,
color: Colors.grey,
),
SizedBox(height: 16),
Text(
"No Dispatches Found",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
"Tap + to create your first dispatch.",
style: TextStyle(
color: Colors.grey,
),
),
],
),
);
}

return Column(
children: [

Padding(
padding: const EdgeInsets.all(12),
child: TextField(
controller: _searchController,
decoration: InputDecoration(
hintText: "Search dispatch...",
prefixIcon: const Icon(Icons.search),
suffixIcon: _searchText.isEmpty
? null
: IconButton(
icon: const Icon(Icons.clear),
onPressed: () {
_searchController.clear();
setState(() {
_searchText = "";
});
},
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
onChanged: (value) {
setState(() {
_searchText = value;
});
},
),
),

Expanded(
child: RefreshIndicator(
onRefresh: _refresh,
child: ListView.builder(
padding: const EdgeInsets.only(bottom: 80),
itemCount: filteredDispatches.length,
itemBuilder: (context, index) {

final dispatch = filteredDispatches[index];
return Card(
  elevation: 2,
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    contentPadding: const EdgeInsets.all(16),

    onTap: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DispatchDetailsScreen(
            dispatch: dispatch,
          ),
        ),
      );

      if (result == true) {
        _refresh();
      }
    },

    leading: CircleAvatar(
      radius: 24,
      child: Text(
        dispatch.id.toString(),
      ),
    ),

    title: Text(
      dispatch.dispatchNumber,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),

    subtitle: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const Icon(
                Icons.inventory_2,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Shipment: ${dispatch.shipmentNumber}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.person,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Driver: ${dispatch.driverName}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.local_shipping,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Vehicle: ${dispatch.plateNumber}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          AppStatusChip(
            status: dispatch.status,
          ),
        ],
      ),
    ),

    trailing: const Icon(
      Icons.arrow_forward_ios,
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
);
}
}