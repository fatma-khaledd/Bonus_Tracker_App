import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Empty state placeholder displayed when a screen or section has no records.
///
/// ```dart
/// EmptyStateWidget(message: 'No notes yet')
/// EmptyStateWidget(message: 'No meetings scheduled', icon: Icons.event_busy)
/// ```
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final double? iconSize;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: iconSize ?? 64,
              color: AppColors.borderLight,
            ),
            const SizedBox(height: AppDimens.lg),
            Text(
              message,
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
