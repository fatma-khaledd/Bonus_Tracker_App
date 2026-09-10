import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_button.dart';

/// Modal bottom sheet wrapper with top drag handle, scrollable body, and action buttons.
///
/// ```dart
/// showAppBottomSheet(
///   context,
///   content: const Column(
///     children: [
///       AppTextField(label: 'Title'),
///     ],
///   ),
///   onDone: () => saveData(),
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  final Widget content;
  final VoidCallback? onCancel;
  final VoidCallback? onDone;
  final String cancelText;
  final String doneText;

  const AppBottomSheet({
    super.key,
    required this.content,
    this.onCancel,
    this.onDone,
    this.cancelText = 'Cancel',
    this.doneText = 'Done',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.bottomSheetRadius),
          topRight: Radius.circular(AppDimens.bottomSheetRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimens.md),
          Container(
            width: AppDimens.bottomSheetHandleWidth,
            height: AppDimens.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(height: AppDimens.xl),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPaddingH,
              ),
              child: content,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.screenPaddingH),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    text: cancelText,
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: AppButton.secondary(text: doneText, onPressed: onDone),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// Helper function to display the standard [AppBottomSheet].
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget content,
  VoidCallback? onDone,
  VoidCallback? onCancel,
  String cancelText = 'Cancel',
  String doneText = 'Done',
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AppBottomSheet(
        content: content,
        onDone: onDone,
        onCancel: onCancel,
        cancelText: cancelText,
        doneText: doneText,
      ),
    ),
  );
}
