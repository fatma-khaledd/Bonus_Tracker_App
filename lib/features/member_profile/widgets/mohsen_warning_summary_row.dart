import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/stat_box.dart';
import 'add_mohsen_dialog.dart';
import 'mohsen_history_bottom_sheet.dart';

/// Displays summary cards for Mohsens and Warnings counts.
/// Tapping a card opens the history bottom sheet with real-time Firebase sync,
/// edit and delete actions, and top-right add button.
class MohsenWarningSummaryRow extends StatelessWidget {
  final int mohsensCount;
  final int warningsCount;
  final String? committeeId;
  final String? memberId;
  final void Function(AddMohsenResult result)? onMohsenAdded;
  final void Function(AddMohsenResult result)? onWarningAdded;

  const MohsenWarningSummaryRow({
    super.key,
    required this.mohsensCount,
    required this.warningsCount,
    this.committeeId,
    this.memberId,
    this.onMohsenAdded,
    this.onWarningAdded,
  });

  void _openMohsensHistory(BuildContext context) {
    MohsenHistoryBottomSheet.show(
      context,
      isMohsen: true,
      committeeId: committeeId ?? 'preview_committee',
      memberId: memberId ?? 'preview_member',
      initialTotal: mohsensCount,
    );
  }

  void _openWarningsHistory(BuildContext context) {
    MohsenHistoryBottomSheet.show(
      context,
      isMohsen: false,
      committeeId: committeeId ?? 'preview_committee',
      memberId: memberId ?? 'preview_member',
      initialTotal: warningsCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Mohsens Box
        Expanded(
          child: GestureDetector(
            onTap: () => _openMohsensHistory(context),
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
            onTap: () => _openWarningsHistory(context),
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
