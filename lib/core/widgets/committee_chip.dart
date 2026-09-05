import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Selectable rounded pill chip used for committee filtering and tab switching.
///
/// ```dart
/// CommitteeChip(
///   label: 'HR',
///   isSelected: true,
///   onTap: () => selectCommittee('HR'),
/// )
/// ```
class CommitteeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CommitteeChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.lg,
          vertical: AppDimens.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chipSelected : AppColors.chipUnselected,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: isSelected
              ? null
              : Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Text(
          label,
          style: isSelected ? AppTextStyles.chipSelected : AppTextStyles.chip,
        ),
      ),
    );
  }
}
