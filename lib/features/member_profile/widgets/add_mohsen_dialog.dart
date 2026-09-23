import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/stepper_input.dart';
import '../../../shared/models/models.dart';

// Result returned when a Mohsen or Warning is submitted
class AddMohsenResult {
  final String title;
  final int value;
  final String reason;
  final bool isMohsen;

  const AddMohsenResult({
    required this.title,
    required this.value,
    required this.reason,
    required this.isMohsen,
  });
}

// Dialog for adding or editing Mohsens or Warnings
class AddMohsenDialog extends StatefulWidget {
  final bool isMohsen;
  final int currentTotal;
  final MohsenEntryModel? entry;
  final String? initialTitle;
  final int? initialValue;
  final String? initialReason;
  final String? submitButtonLabel;
  final String? customTitle;

  const AddMohsenDialog({
    super.key,
    required this.isMohsen,
    this.currentTotal = 0,
    this.entry,
    this.initialTitle,
    this.initialValue,
    this.initialReason,
    this.submitButtonLabel,
    this.customTitle,
  });

  /// Shows the dialog and returns [AddMohsenResult] on success, or null on cancel.
  static Future<AddMohsenResult?> show(
    BuildContext context, {
    required bool isMohsen,
    int currentTotal = 0,
    MohsenEntryModel? entry,
    String? initialTitle,
    int? initialValue,
    String? initialReason,
    String? submitButtonLabel,
    String? customTitle,
  }) {
    return showDialog<AddMohsenResult>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => AddMohsenDialog(
        isMohsen: isMohsen,
        currentTotal: currentTotal,
        entry: entry,
        initialTitle: initialTitle ?? entry?.title,
        initialValue: initialValue ?? entry?.value.toInt(),
        initialReason: initialReason ?? entry?.reason,
        submitButtonLabel: submitButtonLabel,
        customTitle: customTitle,
      ),
    );
  }

  @override
  State<AddMohsenDialog> createState() => _AddMohsenDialogState();
}

class _AddMohsenDialogState extends State<AddMohsenDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _reasonController;
  late int _value;
  String? _titleError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _reasonController = TextEditingController(text: widget.initialReason ?? '');
    _value = widget.initialValue ?? 1;

    _titleController.addListener(() {
      if (_titleError != null && _titleController.text.trim().isNotEmpty) {
        setState(() => _titleError = null);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  String get _dialogTitle =>
      widget.customTitle ?? (widget.isMohsen ? 'Mohsen' : 'Warning');
  String get _titleHint =>
      widget.isMohsen ? 'Enter mohsens title' : 'Enter warning title';

  String get _addButtonLabel => widget.submitButtonLabel ?? 'Done';

  int get _minAllowed {
    final isEdit = widget.entry != null || widget.initialValue != null;
    final oldValue = widget.entry?.value.toInt() ?? widget.initialValue ?? 0;
    final baseTotal =
        isEdit ? (widget.currentTotal - oldValue) : widget.currentTotal;
    if (baseTotal > 0) {
      final calculatedMin = -baseTotal;
      return calculatedMin < -20 ? -20 : calculatedMin;
    }
    return 1;
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _titleError = 'Title is required';
      });
      return;
    }
    Navigator.of(context).pop(
      AddMohsenResult(
        title: title,
        value: _value,
        reason: _reasonController.text.trim(),
        isMohsen: widget.isMohsen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.xxl,
        vertical: AppDimens.xxl,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.lg,
                AppDimens.lg,
                AppDimens.sm,
                0,
              ),
              child: Row(
                children: [
                  Text(_dialogTitle, style: AppTextStyles.heading2),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: AppDimens.iconMd,
                    ),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ],
              ),
            ),

            // Form body
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.lg,
                vertical: AppDimens.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title field
                  _FieldLabel(label: 'Title *'),
                  const SizedBox(height: AppDimens.xs),
                  _DialogTextField(
                    controller: _titleController,
                    hintText: _titleHint,
                    maxLines: 1,
                    errorText: _titleError,
                  ),
                  const SizedBox(height: AppDimens.md),

                  // Value stepper
                  _FieldLabel(label: 'Value'),
                  const SizedBox(height: AppDimens.xs),
                  Row(
                    children: [
                      StepperInput(
                        value: _value,
                        min: _minAllowed,
                        max: 20,
                        skipZero: true,
                        formatValue: (val) => val > 0 ? '+$val' : '$val',
                        onChanged: (val) => setState(() => _value = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.md),

                  // Reason field (optional)
                  _FieldLabel(label: 'Reason'),
                  const SizedBox(height: AppDimens.xs),
                  _DialogTextField(
                    controller: _reasonController,
                    hintText: 'Write reason (optional)',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimens.lg),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _DialogButton(
                          label: 'Cancel',
                          outlined: true,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: AppDimens.md),
                      Expanded(
                        child: _DialogButton(
                          label: _addButtonLabel,
                          outlined: false,
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.xs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widgets

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  final String? errorText;

  const _DialogTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md,
          vertical: AppDimens.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final bool outlined;
  final VoidCallback? onPressed;

  const _DialogButton({
    required this.label,
    required this.outlined,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        height: AppDimens.buttonHeightSm,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.secondary,
            side: const BorderSide(color: AppColors.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.secondary),
          ),
        ),
      );
    }
    return SizedBox(
      height: AppDimens.buttonHeightSm,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}
