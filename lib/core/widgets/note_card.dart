import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Note card displaying title, formatted date, preview content, and an optional completion checkbox.
///
/// ```dart
/// NoteCard(
///   title: 'Session 2 UI',
///   date: 'November 27, 2025',
///   content: '1. Mark attendance\n2. Review tasks...',
///   isDone: false,
///   onTap: () => openNote(),
/// )
/// ```
class NoteCard extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final bool? isDone;
  final ValueChanged<bool?>? onDoneChanged;
  final VoidCallback? onTap;
  final int maxContentLines;

  const NoteCard({
    super.key,
    required this.title,
    required this.date,
    required this.content,
    this.isDone,
    this.onDoneChanged,
    this.onTap,
    this.maxContentLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: AppColors.borderLight, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.xs),
                      Text(date, style: AppTextStyles.cardDate),
                    ],
                  ),
                ),
                if (isDone != null)
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Checkbox(
                      value: isDone,
                      onChanged: onDoneChanged,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.sm),
            Text(
              content,
              style: AppTextStyles.cardBody,
              maxLines: maxContentLines,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
