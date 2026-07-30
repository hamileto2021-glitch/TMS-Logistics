import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const AppPage({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}