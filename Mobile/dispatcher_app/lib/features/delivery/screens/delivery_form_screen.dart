import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../services/delivery_service.dart';
import 'signature_screen.dart';

class DeliveryFormScreen extends StatefulWidget {
  final int tripId;

  const DeliveryFormScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<DeliveryFormScreen> createState() =>
      _DeliveryFormScreenState();
}

class _DeliveryFormScreenState
    extends State<DeliveryFormScreen> {
final _formKey = GlobalKey<FormState>();

final DeliveryService _service = DeliveryService();

final ImagePicker _picker = ImagePicker();

final TextEditingController _receiverController =
TextEditingController();

final TextEditingController _phoneController =
TextEditingController();

final TextEditingController _notesController =
TextEditingController();

File? _deliveryPhoto;
File? _signatureFile;

double? _latitude;
double? _longitude;

bool _loading = false;

@override
void dispose() {
_receiverController.dispose();
_phoneController.dispose();
_notesController.dispose();
super.dispose();
}

Future<void> _pickPhoto() async {
final image = await _picker.pickImage(
source: ImageSource.camera,
imageQuality: 80,
);

if (image == null) return;

setState(() {
_deliveryPhoto = File(image.path);
});
}

Future<void> _captureSignature() async {
final File? file =
await Navigator.push<File>(
context,
MaterialPageRoute(
builder: (_) =>
const SignatureScreen(),
),
);

if (file == null) return;

setState(() {
_signatureFile = file;
});
}

Future<void> _loadLocation() async {
bool enabled =
await Geolocator.isLocationServiceEnabled();

if (!enabled) {
throw Exception(
"Location service is disabled.",
);
}

var permission =
await Geolocator.checkPermission();

if (permission ==
LocationPermission.denied) {
permission =
await Geolocator.requestPermission();
}

if (permission ==
LocationPermission.denied ||
permission ==
LocationPermission.deniedForever) {
throw Exception(
"Location permission denied.",
);
}

final position =
await Geolocator.getCurrentPosition(
desiredAccuracy:
LocationAccuracy.high,
);

_latitude = position.latitude;
_longitude = position.longitude;
}

Future<void> _submit() async {
if (!_formKey.currentState!.validate()) {
return;
}

if (_deliveryPhoto == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content:
Text("Please capture delivery photo."),
),
);
return;
}

if (_signatureFile == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content:
Text("Customer signature is required."),
),
);
return;
}

try {
setState(() {
_loading = true;
});

await _loadLocation();
await _service.completeDelivery(
tripId: widget.tripId,
receiverName: _receiverController.text.trim(),
receiverPhone: _phoneController.text.trim(),
notes: _notesController.text.trim(),
latitude: _latitude!,
longitude: _longitude!,
photo: _deliveryPhoto,
signature: _signatureFile,
);

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Delivery completed successfully.",
),
backgroundColor: Colors.green,
),
);

Navigator.pop(context, true);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(e.toString()),
backgroundColor: Colors.red,
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
title: const Text("Complete Delivery"),
centerTitle: true,
),
body: SafeArea(
child: Form(
key: _formKey,
child: ListView(
padding: const EdgeInsets.all(16),
children: [
TextFormField(
controller: _receiverController,
decoration: const InputDecoration(
labelText: "Receiver Name",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.person),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Receiver name is required.";
}
return null;
},
),

const SizedBox(height: 16),

TextFormField(
controller: _phoneController,
keyboardType: TextInputType.phone,
decoration: const InputDecoration(
labelText: "Receiver Phone",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.phone),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Receiver phone is required.";
}
return null;
},
),

const SizedBox(height: 16),

TextFormField(
controller: _notesController,
maxLines: 4,
decoration: const InputDecoration(
labelText: "Delivery Notes",
border: OutlineInputBorder(),
alignLabelWithHint: true,
prefixIcon: Icon(Icons.notes),
),
),

const SizedBox(height: 20),

SizedBox(
height: 180,
child: Card(
child: _deliveryPhoto == null
? const Center(
child: Text(
"No delivery photo selected.",
),
)
: ClipRRect(
borderRadius:
BorderRadius.circular(12),
child: Image.file(
_deliveryPhoto!,
fit: BoxFit.cover,
),
),
),
),

const SizedBox(height: 12),

SizedBox(
width: double.infinity,
child: OutlinedButton.icon(
onPressed: _loading ? null : _pickPhoto,
icon: const Icon(Icons.camera_alt),
label: const Text("Capture Delivery Photo"),
),
),

const SizedBox(height: 24),
  Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Customer Signature",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 180,
            width: double.infinity,
            child: _signatureFile == null
                ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "No signature captured.",
                ),
              ),
            )
                : ClipRRect(
              borderRadius:
              BorderRadius.circular(12),
              child: Image.file(
                _signatureFile!,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : _captureSignature,
              icon: const Icon(Icons.draw),
              label: const Text(
                "Capture Signature",
              ),
            ),
          ),
        ],
      ),
    ),
  ),

  const SizedBox(height: 30),

  SizedBox(
    height: 55,
    child: ElevatedButton(
      onPressed:
      _loading ? null : _submit,
      child: _loading
          ? const SizedBox(
        width: 24,
        height: 24,
        child:
        CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text(
        "Complete Delivery",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),
],
),
),
),
);
}
}