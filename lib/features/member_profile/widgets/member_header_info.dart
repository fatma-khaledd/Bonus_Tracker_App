import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/avatar_placeholder.dart';
import '../../../core/widgets/progress_bar_indicator.dart';

// Top header showing avatar, member name, monthly score, and email action
class MemberHeaderInfo extends StatelessWidget {
  final String displayName;
  final double scorePercent;
  final String? imageUrl;
  final VoidCallback? onSendEmail;

  const MemberHeaderInfo({
    super.key,
    required this.displayName,
    required this.scorePercent,
    this.imageUrl,
    this.onSendEmail,
  });

  String get _scoreLabel => '${(scorePercent * 100).round()}% this month';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarPlaceholder(
          radius: AppDimens.avatarLg / 2,
          imageUrl: imageUrl,
        ),
        const SizedBox(width: AppDimens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayName,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.xs),
              Text(
                _scoreLabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.xs),
              ProgressBarIndicator(progress: scorePercent),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.md),
        ElevatedButton(
          onPressed: onSendEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textOnSecondary,
            elevation: 0,
            minimumSize: const Size(100, AppDimens.buttonHeightSm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.lg,
              vertical: AppDimens.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
            ),
          ),
          child: Text(
            'Send Email',
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.textOnSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
