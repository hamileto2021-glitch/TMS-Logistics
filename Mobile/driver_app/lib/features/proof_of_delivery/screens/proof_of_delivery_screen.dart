import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../models/proof_of_delivery_model.dart';
import '../services/proof_of_delivery_service.dart';
import '../widgets/notes_widget.dart';
import '../widgets/receiver_form.dart';
import '../widgets/signature_pad.dart';
import '../widgets/submit_button.dart';

class ProofOfDeliveryScreen extends StatefulWidget {
  final int tripId;
  final String shipmentNumber;
  final String customerName;
  final String destination;

  const ProofOfDeliveryScreen({
    super.key,
    required this.tripId,
    required this.shipmentNumber,
    required this.customerName,
    required this.destination,
  });

  @override
  State<ProofOfDeliveryScreen> createState() =>
      _ProofOfDeliveryScreenState();
}

class _ProofOfDeliveryScreenState
    extends State<ProofOfDeliveryScreen> {

final _formKey = GlobalKey<FormState>();

final _receiverController =
TextEditingController();

final _notesController =
TextEditingController();

final SignatureController
_signatureController =
SignatureController(
penStrokeWidth: 3,
penColor: Colors.black,
);

final ProofOfDeliveryService _service =
ProofOfDeliveryService();

File? _photo;

bool _loading = false;

@override
void dispose() {
_receiverController.dispose();
_notesController.dispose();
_signatureController.dispose();
super.dispose();
}

Future<void> _takePhoto() async {
final picker = ImagePicker();

final image = await picker.pickImage(
source: ImageSource.camera,
imageQuality: 80,
);

if (image == null) return;

setState(() {
_photo = File(image.path);
});
}

Future<void> _submit() async {
if (!_formKey.currentState!.validate()) {
return;
}

if (_signatureController.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Receiver signature is required."),
),
);
return;
}

if (_photo == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Delivery photo is required."),
),
);
return;
}

setState(() {
_loading = true;
});

try {
bool serviceEnabled =
await Geolocator.isLocationServiceEnabled();

if (!serviceEnabled) {
throw Exception("Location service is disabled.");
}

LocationPermission permission =
await Geolocator.checkPermission();

if (permission == LocationPermission.denied) {
permission =
await Geolocator.requestPermission();
}

if (permission == LocationPermission.denied ||
permission ==
LocationPermission.deniedForever) {
throw Exception("Location permission denied.");
}

final position =
await Geolocator.getCurrentPosition();

final signatureBytes =
await _signatureController.toPngBytes();

if (signatureBytes == null) {
throw Exception("Unable to save signature.");
}

final directory =
await getApplicationDocumentsDirectory();

final signatureFile = File(
"${directory.path}/signature_${widget.tripId}.png",
);

await signatureFile.writeAsBytes(signatureBytes);

final pod = ProofOfDeliveryModel(
tripId: widget.tripId,
receiverName:
_receiverController.text.trim(),
notes: _notesController.text.trim(),
latitude: position.latitude,
longitude: position.longitude,
signaturePath: signatureFile.path,
photoPath: _photo!.path,
);

await _service.submit(pod);

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
backgroundColor: Colors.green,
content: Text(
"Proof of Delivery uploaded successfully.",
),
),
);

Navigator.pop(context);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.red,
content: Text(e.toString()),
),
);
} finally {
if (mounted) {
setState(() {
_loading = false;
});
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Proof of Delivery"),
),
body: Form(
key: _formKey,
child: ListView(
padding: const EdgeInsets.all(16),
children: [

Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Text(
widget.shipmentNumber,
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(widget.customerName),

const SizedBox(height: 8),

Text(widget.destination),

],
),
),
),

const SizedBox(height: 20),

ReceiverForm(
controller: _receiverController,
),

const SizedBox(height: 20),

SignaturePadWidget(
controller: _signatureController,
),

const SizedBox(height: 20),

Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [

ElevatedButton.icon(
onPressed: _takePhoto,
icon: const Icon(Icons.camera_alt),
label: const Text(
"Take Delivery Photo",
),
),

const SizedBox(height: 15),

if (_photo != null)
ClipRRect(
borderRadius:
BorderRadius.circular(10),
child: Image.file(
_photo!,
width: double.infinity,
height: 220,
fit: BoxFit.cover,
),
),

],
),
),
),

const SizedBox(height: 20),

NotesWidget(
controller: _notesController,
),

const SizedBox(height: 30),

SubmitButton(
loading: _loading,
onPressed: _submit,
),

const SizedBox(height: 30),
],
),
),
);
}
}