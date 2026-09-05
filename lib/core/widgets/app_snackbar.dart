import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Small floating inline notification banner positioned beneath header icons.
///
/// ```dart
/// InlineAlert(
///   message: 'New meeting scheduled',
///   onDismiss: () => setState(() => showAlert = false),
/// )
/// ```
class InlineAlert extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const InlineAlert({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.sm,
      ),
      constraints: const BoxConstraints(maxWidth: 220),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              'Alert: $message',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppDimens.xs),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper function to display standard floating SnackBar feedback messages.
void showAppSnackbar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyles.body.copyWith(color: Colors.white),
      ),
      backgroundColor: isError ? AppColors.error : AppColors.secondary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
