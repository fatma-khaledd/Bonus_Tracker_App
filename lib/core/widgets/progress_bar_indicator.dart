import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Progress bar indicator that dynamically colors based on threshold values:
/// - Green: >= 85%
/// - Orange: 50% - 84%
/// - Red: < 50%
///
/// ```dart
/// ProgressBarIndicator(progress: 0.90, label: '90% Attendance')
/// ```
class ProgressBarIndicator extends StatelessWidget {
  final double progress;
  final String? label;
  final double? height;

  const ProgressBarIndicator({
    super.key,
    required this.progress,
    this.label,
    this.height,
  });

  Color get _progressColor {
    if (progress >= 0.85) return AppColors.progressHigh;
    if (progress >= 0.50) return AppColors.progressMedium;
    return AppColors.progressLow;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.progressBarRadius),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: height ?? AppDimens.progressBarHeight,
            backgroundColor: AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: AppDimens.xs),
          Text(label!, style: AppTextStyles.progressLabel),
        ],
      ],
    );
  }
}
