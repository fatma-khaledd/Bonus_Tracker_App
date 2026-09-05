import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Square-ish card showing a large stat number and label underneath.
/// Used in Home and Member Profile for counts like Mohsens and Warnings.
///
/// ```dart
/// StatBox(
///   value: '10',
///   label: 'Mohsens',
///   color: AppColors.primary,
/// )
/// ```
class StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;
  final double? valueFontSize;

  const StatBox({
    super.key,
    required this.value,
    required this.label,
    this.color,
    this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.xl,
        vertical: AppDimens.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.statLabel,
          ),
          const SizedBox(height: AppDimens.sm),
          Text(
            value,
            style: AppTextStyles.statNumber(
              color: color ?? AppColors.textPrimary,
              fontSize: valueFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
