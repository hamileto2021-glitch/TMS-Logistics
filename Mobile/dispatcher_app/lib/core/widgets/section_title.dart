import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onMore;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [

          Icon(icon),

          const SizedBox(width: 8),

          Text(
            title,
            style: AppTextStyles.sectionTitle,
          ),

          const Spacer(),

          if (onMore != null)
            TextButton(
              onPressed: onMore,
              child: const Text("View All"),
            ),
        ],
      ),
    );
  }
}