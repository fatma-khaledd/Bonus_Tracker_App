import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class VerticalStatDivider extends StatelessWidget {
  const VerticalStatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 30, width: 1, color: AppColors.darkSurfaceVariant);
  }
}
