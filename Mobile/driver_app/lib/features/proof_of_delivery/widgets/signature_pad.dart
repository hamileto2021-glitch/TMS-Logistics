import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePadWidget extends StatelessWidget {
  final SignatureController controller;

  const SignaturePadWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Receiver Signature",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Signature(
                controller: controller,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text("Clear"),
                onPressed: () {
                  controller.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}