import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Status of a meeting/event entry.
enum EntryStatus {
  /// Attended — shows green ✓.
  attended,

  /// Absent / missed — shows red ✗.
  absent,

  /// No status icon.
  none,
}

/// Horizontal card for Meetings/Events list items.
/// Shows title, date, time, optional status icon, and supports onTap.
///
/// ```dart
/// ListEntryCard(
///   title: 'Session 3',
///   date: 'Sun - 08/16',
///   time: '07:00 pm',
///   status: EntryStatus.attended,
///   onTap: () => _openSession(),
/// )
/// ```
class ListEntryCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final EntryStatus status;
  final VoidCallback? onTap;

  const ListEntryCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    this.status = EntryStatus.none,
    this.onTap,
  });

  Widget? _buildStatusIcon() {
    switch (status) {
      case EntryStatus.attended:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        );
      case EntryStatus.absent:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 14),
        );
      case EntryStatus.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusIcon = _buildStatusIcon();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (statusIcon != null) ...[
                  statusIcon,
                  const SizedBox(width: AppDimens.xs),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.cardTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: AppDimens.iconMd,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.xs),
            Text(date, style: AppTextStyles.cardDate),
            Text(time, style: AppTextStyles.cardDate),
          ],
        ),
      ),
    );
  }
}
