import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/models/models.dart';
import '../../../shared/repositories/mohsens/firestore_mohsens_repository.dart';
import '../cubit/member_profile_cubit.dart';
import '../cubit/member_profile_state.dart';
import 'add_mohsen_dialog.dart';

class MohsenHistoryBottomSheet extends StatefulWidget {
  final bool isMohsen;
  final String committeeId;
  final String memberId;
  final int initialTotal;
  final MemberProfileCubit? cubit;

  const MohsenHistoryBottomSheet({
    super.key,
    required this.isMohsen,
    required this.committeeId,
    required this.memberId,
    required this.initialTotal,
    this.cubit,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isMohsen,
    required String committeeId,
    required String memberId,
    required int initialTotal,
    MemberProfileCubit? cubit,
  }) {
    MemberProfileCubit? effectiveCubit = cubit;
    if (effectiveCubit == null) {
      try {
        effectiveCubit = context.read<MemberProfileCubit>();
      } catch (_) {}
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MohsenHistoryBottomSheet(
        isMohsen: isMohsen,
        committeeId: committeeId,
        memberId: memberId,
        initialTotal: initialTotal,
        cubit: effectiveCubit,
      ),
    );
  }

  @override
  State<MohsenHistoryBottomSheet> createState() =>
      _MohsenHistoryBottomSheetState();
}

class _MohsenHistoryBottomSheetState extends State<MohsenHistoryBottomSheet> {
  late final FirestoreMohsensRepository? _repository;
  List<MohsenEntryModel> _localEntries = [];
  bool _isFirebaseAvailable = false;

  @override
  void initState() {
    super.initState();
    _isFirebaseAvailable = Firebase.apps.isNotEmpty;
    _repository = _isFirebaseAvailable ? FirestoreMohsensRepository() : null;

    if (!_isFirebaseAvailable) {
      _localEntries = _getDefaultSampleEntries();
    }
  }

  List<MohsenEntryModel> _getDefaultSampleEntries() {
    final now = DateTime.now();
    return [
      MohsenEntryModel(
        id: 'sample_1',
        committeeId: widget.committeeId,
        memberId: widget.memberId,
        type: widget.isMohsen ? MohsenType.mohsen : MohsenType.warning,
        title: widget.isMohsen
            ? 'was active in session 2'
            : 'late for session 1',
        value: 1,
        reason: widget.isMohsen
            ? 'was active in session 2'
            : 'late for session 1',
        addedBy: 'hr_user',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Short month abbreviations (first 3 letters) for the card date label
  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime dateTime) {
    final month = _shortMonths[dateTime.month - 1];
    return '$month ${dateTime.day}';
  }

  int _getCurrentCount() {
    if (widget.cubit != null) {
      return widget.isMohsen
          ? widget.cubit!.state.mohsensCount
          : widget.cubit!.state.warningsCount;
    }
    return widget.initialTotal;
  }

  Future<void> _onAddTap() async {
    final currentCount = _getCurrentCount();
    final result = await AddMohsenDialog.show(
      context,
      isMohsen: widget.isMohsen,
      currentTotal: currentCount,
      submitButtonLabel: 'Done',
    );

    if (result != null && mounted) {
      if (widget.cubit != null) {
        await widget.cubit!.addMohsenOrWarning(
          committeeId: widget.committeeId,
          memberId: widget.memberId,
          title: result.title,
          value: result.value,
          reason: result.reason,
          isMohsen: widget.isMohsen,
        );
      } else {
        setState(() {
          _localEntries.insert(
            0,
            MohsenEntryModel(
              id: 'local_${DateTime.now().millisecondsSinceEpoch}',
              committeeId: widget.committeeId,
              memberId: widget.memberId,
              type: widget.isMohsen ? MohsenType.mohsen : MohsenType.warning,
              title: result.title,
              value: result.value,
              reason: result.reason,
              addedBy: 'user',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        });
      }
    }
  }

  Future<void> _onEditEntry(MohsenEntryModel entry) async {
    final currentCount = _getCurrentCount();
    final result = await AddMohsenDialog.show(
      context,
      isMohsen: widget.isMohsen,
      currentTotal: currentCount,
      entry: entry,
      initialTitle: entry.title.isNotEmpty ? entry.title : entry.reason,
      initialValue: entry.value.toInt(),
      initialReason: entry.reason,
      submitButtonLabel: 'Done',
    );

    if (result != null && mounted) {
      final updatedEntry = entry.copyWith(
        title: result.title,
        value: result.value,
        reason: result.reason,
        updatedAt: DateTime.now(),
      );

      if (widget.cubit != null) {
        await widget.cubit!.updateMohsenOrWarning(
          committeeId: widget.committeeId,
          memberId: widget.memberId,
          oldEntry: entry,
          newEntry: updatedEntry,
        );
      } else {
        setState(() {
          final index = _localEntries.indexWhere((e) => e.id == entry.id);
          if (index != -1) {
            _localEntries[index] = updatedEntry;
          }
        });
      }
    }
  }

  Future<void> _onDeleteEntry(MohsenEntryModel entry) async {
    final currentCount = _getCurrentCount();
    if (currentCount - entry.value < 0) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          title: Text(
            'Cannot Delete ${widget.isMohsen ? "Mohsen" : "Warning"}',
            style: AppTextStyles.heading2,
          ),
          content: Text(
            'This entry cannot be deleted because removing it would make the total negative.',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        title: Text(
          'Delete ${widget.isMohsen ? "Mohsen" : "Warning"}',
          style: AppTextStyles.heading2,
        ),
        content: Text(
          'Are you sure you want to delete "${entry.title.isNotEmpty ? entry.title : entry.reason}"?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      if (widget.cubit != null) {
        await widget.cubit!.deleteMohsenOrWarning(
          committeeId: widget.committeeId,
          memberId: widget.memberId,
          entry: entry,
        );
      } else {
        setState(() {
          _localEntries.removeWhere((e) => e.id == entry.id);
        });
      }
    }
  }

  Widget _buildEntryCard(MohsenEntryModel entry) {
    final label = entry.title.isNotEmpty ? entry.title : entry.reason;
    final displayValue = entry.value.toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8C8A3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Left: Value and Date
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$displayValue',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(entry.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Middle: Title / Reason
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (entry.title.isNotEmpty &&
                    entry.reason.isNotEmpty &&
                    entry.title != entry.reason)
                  Text(
                    entry.reason,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          // Right: Edit and Delete icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                iconSize: 20,
                color: AppColors.secondary,
                tooltip: 'Edit',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                splashRadius: 18,
                onPressed: () => _onEditEntry(entry),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                color: AppColors.error,
                tooltip: 'Delete',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                splashRadius: 18,
                onPressed: () => _onDeleteEntry(entry),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListContent(List<MohsenEntryModel> entries) {
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isMohsen
                  ? Icons.star_border_rounded
                  : Icons.warning_amber_rounded,
              size: 48,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No ${widget.isMohsen ? "Mohsens" : "Warnings"} yet',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap the + button to add one',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) => _buildEntryCard(entries[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubitWidget = widget.cubit;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFDECD8),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Handle Bar
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with circular '+' button aligned to the right
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isMohsen ? 'Mohsens' : 'Warnings',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: _onAddTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable History Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isFirebaseAvailable && _repository != null
                    ? StreamBuilder<List<MohsenEntryModel>>(
                        stream: _repository.streamMohsensHistory(
                          committeeId: widget.committeeId,
                          uid: widget.memberId,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              !snapshot.hasData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(
                                  color: AppColors.secondary,
                                ),
                              ),
                            );
                          }

                          final allEntries = snapshot.data ?? [];
                          final filtered = allEntries
                              .where(
                                (e) =>
                                    e.type ==
                                    (widget.isMohsen
                                        ? MohsenType.mohsen
                                        : MohsenType.warning),
                              )
                              .toList();

                          return _buildListContent(filtered);
                        },
                      )
                    : _buildListContent(_localEntries),
              ),
            ),

            // Bottom Footer Summary: label + Count
            Container(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE0C9A6), width: 1),
                ),
              ),
              child: cubitWidget != null
                  ? BlocBuilder<MemberProfileCubit, MemberProfileState>(
                      bloc: cubitWidget,
                      builder: (context, state) {
                        final total = widget.isMohsen
                            ? state.mohsensCount
                            : state.warningsCount;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.isMohsen ? 'Mohsens' : 'Warnings',
                              style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$total',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isMohsen ? 'Mohsens' : 'Warnings',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${widget.initialTotal}',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
