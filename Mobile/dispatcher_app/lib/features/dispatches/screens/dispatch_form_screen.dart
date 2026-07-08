import 'package:flutter/material.dart';

import '../services/dispatch_service.dart';
import '../../../core/services/driver_service.dart';
import '../../../core/services/shipment_service.dart';
import '../../../core/services/vehicle_service.dart';

import '../../../models/dispatch.dart';
import '../../../models/driver.dart';
import '../../../models/shipment.dart';
import '../../../models/vehicle.dart';

class DispatchFormScreen extends StatefulWidget {
  final Dispatch? dispatch;

  const DispatchFormScreen({
    super.key,
    this.dispatch,
  });

  @override
  State<DispatchFormScreen> createState() =>
      _DispatchFormScreenState();
}

class _DispatchFormScreenState
    extends State<DispatchFormScreen> {

final _formKey = GlobalKey<FormState>();

final DispatchService _dispatchService =
DispatchService();

final ShipmentService _shipmentService =
ShipmentService();

final DriverService _driverService =
DriverService();

final VehicleService _vehicleService =
VehicleService();

List<Shipment> shipments = [];

List<Vehicle> vehicles = [];

List<Driver> drivers = [];

Shipment? selectedShipment;

Vehicle? selectedVehicle;

Driver? selectedDriver;

DateTime dispatchDate = DateTime.now();

final notesController =
TextEditingController();

bool loading = true;

bool saving = false;

String status = "Scheduled";

@override
void initState() {
super.initState();
_loadData();
}

Future<void> _loadData() async {

shipments =
await _shipmentService.getShipments();

vehicles =
await _vehicleService.getVehicles();

drivers =
await _driverService.getDrivers();

if (widget.dispatch != null) {

final dispatch = widget.dispatch!;

selectedShipment = shipments.firstWhere(
(e) => e.id == dispatch.shipmentId,
);

selectedVehicle = vehicles.firstWhere(
(e) => e.id == dispatch.vehicleId,
);

selectedDriver = drivers.firstWhere(
(e) => e.id == dispatch.driverId,
);

dispatchDate = dispatch.dispatchDate;

notesController.text = dispatch.notes;

status = dispatch.status;
}

if (mounted) {
setState(() {
loading = false;
});
}
}
Future<void> _pickDate() async {

final date = await showDatePicker(
context: context,
initialDate: dispatchDate,
firstDate: DateTime(2024),
lastDate: DateTime(2100),
);

if (date != null) {
setState(() {
dispatchDate = date;
});
}
}

@override
void dispose() {
notesController.dispose();
super.dispose();
}
@override
Widget build(BuildContext context) {

if (loading) {
return Scaffold(
appBar: AppBar(
title: const Text("Dispatch"),
),
body: const Center(
child: CircularProgressIndicator(),
),
);
}

return Scaffold(
appBar: AppBar(
title: Text(
widget.dispatch == null
? "New Dispatch"
: "Edit Dispatch",
),
),

body: Form(
key: _formKey,

child: ListView(
padding: const EdgeInsets.all(16),

children: [

DropdownButtonFormField<Shipment>(
value: selectedShipment,
decoration: const InputDecoration(
labelText: "Shipment",
border: OutlineInputBorder(),
),

items: shipments.map((shipment) {

return DropdownMenuItem(
value: shipment,
child: Text(
shipment.shipmentNumber,
),
);

}).toList(),

validator: (value) {
if (value == null) {
return "Select shipment";
}
return null;
},

onChanged: (value) {
setState(() {
selectedShipment = value;
});
},
),

const SizedBox(height: 16),

DropdownButtonFormField<Vehicle>(
value: selectedVehicle,
decoration: const InputDecoration(
labelText: "Vehicle",
border: OutlineInputBorder(),
),

items: vehicles.map((vehicle) {

return DropdownMenuItem(
value: vehicle,
child: Text(
"${vehicle.plateNumber} (${vehicle.vehicleCode})",
),
);

}).toList(),

validator: (value) {
if (value == null) {
return "Select vehicle";
}
return null;
},

onChanged: (value) {
setState(() {
selectedVehicle = value;
});
},
),

const SizedBox(height: 16),

DropdownButtonFormField<Driver>(
value: selectedDriver,
decoration: const InputDecoration(
labelText: "Driver",
border: OutlineInputBorder(),
),

items: drivers.map((driver) {

return DropdownMenuItem(
value: driver,
child: Text(
driver.fullName,
),
);

}).toList(),

validator: (value) {
if (value == null) {
return "Select driver";
}
return null;
},

onChanged: (value) {
setState(() {
selectedDriver = value;
});
},
),

const SizedBox(height: 16),

ListTile(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
side: const BorderSide(
color: Colors.grey,
),
),

leading: const Icon(
Icons.calendar_month,
),

title: Text(
"${dispatchDate.day}/${dispatchDate.month}/${dispatchDate.year}",
),

trailing: const Icon(
Icons.edit_calendar,
),

onTap: _pickDate,
),

const SizedBox(height: 16),

DropdownButtonFormField<String>(
value: status,

decoration: const InputDecoration(
labelText: "Status",
border: OutlineInputBorder(),
),

items: const [

DropdownMenuItem(
value: "Scheduled",
child: Text("Scheduled"),
),

DropdownMenuItem(
value: "In Progress",
child: Text("In Progress"),
),

DropdownMenuItem(
value: "Completed",
child: Text("Completed"),
),

DropdownMenuItem(
value: "Cancelled",
child: Text("Cancelled"),
),
],

onChanged: (value) {
setState(() {
status = value!;
});
},
),

const SizedBox(height: 16),

TextFormField(
controller: notesController,
maxLines: 4,

decoration: const InputDecoration(
labelText: "Notes",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 30),
SizedBox(
width: double.infinity,
height: 52,
child: ElevatedButton.icon(
icon: saving
? const SizedBox(
width: 20,
height: 20,
child: CircularProgressIndicator(
strokeWidth: 2,
color: Colors.white,
),
)
: const Icon(Icons.save),

label: Text(
widget.dispatch == null
? "SAVE DISPATCH"
: "UPDATE DISPATCH",
),

onPressed: saving
? null
: () async {

if (!_formKey.currentState!.validate()) {
return;
}

if (selectedShipment == null ||
selectedVehicle == null ||
selectedDriver == null) {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Please complete all fields.",
),
),
);

return;
}

setState(() {
saving = true;
});

try {

final dispatch = Dispatch(
id: widget.dispatch?.id ?? 0,

dispatchNumber:
widget.dispatch?.dispatchNumber ?? "",

shipmentId: selectedShipment!.id,
shipmentNumber:
selectedShipment!.shipmentNumber,

vehicleId: selectedVehicle!.id,
vehiclePlate:
selectedVehicle!.plateNumber,

driverId: selectedDriver!.id,
driverName:
selectedDriver!.fullName,

dispatchDate: dispatchDate,

status: status,

notes: notesController.text.trim(),
);

if (widget.dispatch == null) {

await _dispatchService.createDispatch(
dispatch,
);

} else {

await _dispatchService.updateDispatch(
dispatch,
);

}

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.green,
content: Text(
widget.dispatch == null
? "Dispatch created successfully."
: "Dispatch updated successfully.",
),
),
);

Navigator.pop(context, true);

} catch (e) {

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.red,
content: Text(
e.toString(),
),
),
);

} finally {

if (mounted) {
setState(() {
saving = false;
});
}

}
},
),
),
],
),
),
);
}
}