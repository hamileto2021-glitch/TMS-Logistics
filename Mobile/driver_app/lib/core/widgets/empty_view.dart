import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {

  final String title;

  const EmptyView({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          const Icon(
            Icons.inbox,
            size: 70,
            color: Colors.grey,
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(fontSize: 18),
          )

        ],
      ),
    );
  }
}