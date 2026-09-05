import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_button.dart';

/// Card item for Mohsen and Warning history log.
/// Displays value number, date, activity description, and an optional edit action.
///
/// ```dart
/// HistoryEntryCard(
///   value: 1,
///   description: 'Active in session 2',
///   date: 'August 19, 2026',
///   onEdit: () => openEditDialog(),
/// )
/// ```
class HistoryEntryCard extends StatelessWidget {
  final int value;
  final String description;
  final String date;
  final VoidCallback? onEdit;

  const HistoryEntryCard({
    super.key,
    required this.value,
    required this.description,
    required this.date,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.lg,
        vertical: AppDimens.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                value.toString(),
                style: AppTextStyles.statNumber(fontSize: 28),
              ),
              Text(date, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(width: AppDimens.lg),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimens.sm),
          if (onEdit != null)
            SizedBox(
              height: AppDimens.buttonHeightSm,
              child: AppButton(
                text: 'Edit',
                onPressed: onEdit,
                style: AppButtonStyle.secondary,
                height: AppDimens.buttonHeightSm,
              ),
            ),
        ],
      ),
    );
  }
}
