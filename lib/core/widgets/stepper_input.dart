import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Numeric value stepper with increment (+) and decrement (-) buttons.
/// Used in Add Mohsen/Warning bottom sheet.
///
/// ```dart
/// StepperInput(
///   value: count,
///   onChanged: (newVal) => setState(() => count = newVal),
///   min: 1,
///   max: 20,
/// )
/// ```
class StepperInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const StepperInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.add,
          onTap: value < max ? () => onChanged(value + 1) : null,
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 48),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
          child: Text(value.toString(), style: AppTextStyles.heading2),
        ),
        _StepperButton(
          icon: Icons.remove,
          onTap: value > min ? () => onChanged(value - 1) : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.borderLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          border: Border.all(
            color: isDisabled ? AppColors.borderLight : AppColors.border,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDisabled ? AppColors.textSecondary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
