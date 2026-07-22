import 'package:flutter/material.dart';

class ReceiverForm extends StatelessWidget {
  final TextEditingController controller;

  const ReceiverForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Receiver Name",
        hintText: "Enter receiver's full name",
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Receiver name is required";
        }
        return null;
      },
    );
  }
}