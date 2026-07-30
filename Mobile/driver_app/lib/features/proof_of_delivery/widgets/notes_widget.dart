import 'package:flutter/material.dart';

class NotesWidget extends StatelessWidget {
  final TextEditingController controller;

  const NotesWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: "Delivery Notes",
        hintText: "Optional notes...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}