import 'package:flutter/material.dart';
import '../theme/theme.dart';

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
  final num value;
  final String description;
  final String date;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HistoryEntryCard({
    super.key,
    required this.value,
    required this.description,
    required this.date,
    this.onEdit,
    this.onDelete,
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
                _formatNumber(value),
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
          if (onEdit != null || onDelete != null)
            PopupMenuButton<_HistoryAction>(
              tooltip: 'Entry actions',
              icon: const Icon(Icons.more_vert),
              onSelected: (action) {
                switch (action) {
                  case _HistoryAction.edit:
                    onEdit?.call();
                  case _HistoryAction.delete:
                    onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  const PopupMenuItem(
                    value: _HistoryAction.edit,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                    ),
                  ),
                if (onDelete != null)
                  const PopupMenuItem(
                    value: _HistoryAction.delete,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      title: Text(
                        'Delete',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatNumber(num number) {
    return number % 1 == 0 ? number.toInt().toString() : number.toString();
  }
}

enum _HistoryAction { edit, delete }
