import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  const StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
      ],
    );
  }
}

class Divider extends StatelessWidget {
  const Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.darkSurfaceVariant,
    );
  }
}