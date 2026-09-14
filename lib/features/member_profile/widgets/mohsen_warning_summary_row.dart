import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/stat_box.dart';
import 'add_mohsen_dialog.dart';

// Displays summary cards for Mohsens and Warnings counts.
// Tapping a card opens the add dialog.
class MohsenWarningSummaryRow extends StatelessWidget {
  final int mohsensCount;
  final int warningsCount;
  final void Function(AddMohsenResult result)? onMohsenAdded;
  final void Function(AddMohsenResult result)? onWarningAdded;

  const MohsenWarningSummaryRow({
    super.key,
    required this.mohsensCount,
    required this.warningsCount,
    this.onMohsenAdded,
    this.onWarningAdded,
  });

  Future<void> _openAddMohsen(BuildContext context) async {
    final result = await AddMohsenDialog.show(context, isMohsen: true);
    if (result != null && context.mounted) {
      onMohsenAdded?.call(result);
    }
  }

  Future<void> _openAddWarning(BuildContext context) async {
    final result = await AddMohsenDialog.show(context, isMohsen: false);
    if (result != null && context.mounted) {
      onWarningAdded?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Mohsens Box
        Expanded(
          child: GestureDetector(
            onTap: () => _openAddMohsen(context),
            child: StatBox(
              label: 'Mohsens',
              value: mohsensCount.toString(),
              color: AppColors.secondary,
              valueFontSize: 36,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.md),

        // Warnings Box
        Expanded(
          child: GestureDetector(
            onTap: () => _openAddWarning(context),
            child: StatBox(
              label: 'Warnings',
              value: warningsCount.toString(),
              color: AppColors.secondary,
              valueFontSize: 36,
            ),
          ),
        ),
      ],
    );
  }
}
