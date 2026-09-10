import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';
import '../../../shared/models/mohsen_entry_model.dart';

class MohsenHistoryBottomSheet extends StatelessWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onDelete;
  final VoidCallback? onClose;
  final void Function(MohsenEntryModel)? onEdit;

  const MohsenHistoryBottomSheet({
    super.key,
    this.onAdd,
    this.onDelete,
    this.onClose,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimens.bottomSheetRadius),
            topRight: Radius.circular(AppDimens.bottomSheetRadius),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              const SizedBox(height: AppDimens.md),

              Container(
                width: AppDimens.bottomSheetHandleWidth,
                height: AppDimens.bottomSheetHandleHeight,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),

              const SizedBox(height: AppDimens.lg),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mohsens',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),

                    // Close button
                    IconButton(
                      onPressed:
                          onClose ??
                          () {
                            Navigator.of(context).pop();
                          },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textPrimary,
                      ),
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),

              // Add button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: AppColors.secondary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onAdd,
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: AppDimens.iconMd,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimens.sm),

              Flexible(
                child: BlocBuilder<HistoryCubit, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is HistoryEmpty) {
                      return const Center(child: Text('No history yet'));
                    }

                    if (state is HistoryError) {
                      return Center(
                        child: Text(state.message, textAlign: TextAlign.center),
                      );
                    }

                    if (state is HistorySuccess) {
                      final entries = state.entries;

                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.lg,
                          vertical: AppDimens.sm,
                        ),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppDimens.sm),
                        itemBuilder: (context, index) {
                          final entry = entries[index];

                          return _MohsenHistoryItem(
                            number: index + 1,
                            value: entry.value.toInt(),
                            description: entry.reason,
                            date: entry.createdAt.toString(),
                            onEdit: () {
                              context.read<HistoryCubit>().updateEntry(
                                entryId: entry.id,
                                newValue: 3,
                                newReason: entry.reason,
                              );
                            },
                            onDelete: () {
                              context.read<HistoryCubit>().deleteEntry(
                                entry.id,
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  num total = 0;

                  if (state is HistorySuccess) {
                    total = state.total;
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.lg,
                      AppDimens.sm,
                      AppDimens.lg,
                      AppDimens.lg,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Total Mohsens',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          total.toString(),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MohsenHistoryItem extends StatelessWidget {
  final int number;
  final int value;
  final String description;
  final String date;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MohsenHistoryItem({
    required this.number,
    required this.value,
    required this.description,
    required this.date,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Row(
        children: [
          // Entry number
          SizedBox(
            width: 34,
            child: Text(
              number.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: AppDimens.sm),

          // Description + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppDimens.sm),

          // + value
          Text(
            '+$value',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(width: AppDimens.sm),

          // Edit icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondary),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: AppDimens.iconSm,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
