import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
final SignatureController _controller = SignatureController(
penStrokeWidth: 3,
exportBackgroundColor: Colors.white,
);

bool _saving = false;

@override
void dispose() {
_controller.dispose();
super.dispose();
}

Future<void> _saveSignature() async {
if (_controller.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Please capture customer signature.",
),
),
);
return;
}

try {
setState(() {
_saving = true;
});

final Uint8List? data = await _controller.toPngBytes();

if (data == null) {
throw Exception("Unable to generate signature.");
}

final directory =
await getTemporaryDirectory();

final file = File(
"${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png",
);

await file.writeAsBytes(data);

if (!mounted) return;

Navigator.pop(context, file);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
e.toString(),
),
),
);
} finally {
if (mounted) {
setState(() {
_saving = false;
});
}
}
}

void _clearSignature() {
_controller.clear();
setState(() {});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Customer Signature"),
centerTitle: true,
actions: [
IconButton(
onPressed: _saving
? null
: _clearSignature,
icon: const Icon(Icons.delete_outline),
tooltip: "Clear",
),
],
),
body: SafeArea(
child: Column(
children: [
Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
color: Colors.blue.shade50,
child: const Text(
"Ask the customer to sign inside the box below.",
style: TextStyle(
fontWeight: FontWeight.w600,
),
),
),

const SizedBox(height: 16),

Expanded(
child: Padding(
padding: const EdgeInsets.symmetric(
horizontal: 16,
),
child: Container(
decoration: BoxDecoration(
border: Border.all(
color: Colors.grey,
),
borderRadius:
BorderRadius.circular(12),
),
child: Signature(
controller: _controller,
backgroundColor: Colors.white,
),
),
),
),

  const SizedBox(height: 20),

  Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _saving
                ? null
                : () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text("Cancel"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: _saving ? null : _clearSignature,
            icon: const Icon(Icons.refresh),
            label: const Text("Clear"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 2,
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveSignature,
              child: _saving
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                  SizedBox(width: 8),
                  Text("Save Signature"),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),

  const SizedBox(height: 16),
],
),
),
);
}
}