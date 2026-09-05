import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'avatar_placeholder.dart';
import 'progress_bar_indicator.dart';

/// Member summary tile for the HR dashboard list showing avatar, name, monthly progress, and count badges.
///
/// ```dart
/// MemberProgressListItem(
///   name: 'Ahmed',
///   progress: 0.90,
///   mohsensCount: 8,
///   warningsCount: 0,
///   onTap: () => openMemberProfile(member),
/// )
/// ```
class MemberProgressListItem extends StatelessWidget {
  final String name;
  final double progress;
  final int mohsensCount;
  final int warningsCount;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const MemberProgressListItem({
    super.key,
    required this.name,
    required this.progress,
    required this.mohsensCount,
    required this.warningsCount,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.md,
          horizontal: AppDimens.sm,
        ),
        child: Row(
          children: [
            AvatarPlaceholder(
              radius: AppDimens.avatarMd / 2,
              imageUrl: avatarUrl,
            ),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.bodyBold),
                  const SizedBox(height: AppDimens.xs),
                  ProgressBarIndicator(
                    progress: progress,
                    label: '${(progress * 100).toInt()}% this month',
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.md),
            _CountLabel(label: 'Mohsens', count: mohsensCount),
            const SizedBox(width: AppDimens.md),
            _CountLabel(label: 'Warnings', count: warningsCount),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountLabel extends StatelessWidget {
  final String label;
  final int count;

  const _CountLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(
          count.toString(),
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
