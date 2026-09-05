import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Small dropdown selection chip used for setting task and attendance statuses.
///
/// ```dart
/// TaskStatusDropdownChip(
///   currentStatus: 'Completed early',
///   options: const [
///     'Completed early',
///     'Late excused',
///     'Not delivered',
///     'Absent excused',
///   ],
///   onChanged: (value) => updateStatus(value),
/// )
/// ```
class TaskStatusDropdownChip extends StatelessWidget {
  final String currentStatus;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  const TaskStatusDropdownChip({
    super.key,
    required this.currentStatus,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (context) => options
          .map((option) => PopupMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: option == currentStatus
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm,
          vertical: AppDimens.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          border: Border.all(color: AppColors.borderLight, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                currentStatus,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppDimens.xs),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
