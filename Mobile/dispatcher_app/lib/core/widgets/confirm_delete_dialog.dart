import 'package:flutter/material.dart';

class ConfirmDeleteDialog {
  static Future<bool> show(
      BuildContext context, {
        String title = "Delete",
        String message = "Are you sure you want to delete this item?",
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
            size: 40,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.delete),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              label: const Text("Delete"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}