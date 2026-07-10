import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.title,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.title,
  );

  static const TextStyle cardNumber = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.title,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.title,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 13,
    color: AppColors.subtitle,
  );
}