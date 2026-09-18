import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/repositories/mohsens/firestore_mohsens_repository.dart';
import '../../../shared/repositories/mohsens/mohsens_repository.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';

class MohsenHistoryBottomSheet extends StatelessWidget {
  final VoidCallback? onAdd;

  const MohsenHistoryBottomSheet({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listenWhen: (previous, current) =>
          current is HistorySuccess && current.actionError != null,
      listener: (context, state) {
        if (state case HistorySuccess(actionError: final String message)) {
          showAppSnackbar(context, message, isError: true);
        }
      },
      builder: (context, state) {
        return AppBottomSheet(
          cancelText: 'Close',
          doneText: 'Add',
          onDone: onAdd,
          showDoneButton: onAdd != null,
          content: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mohsens', style: AppTextStyles.heading1),
                const SizedBox(height: AppDimens.lg),
                Expanded(child: _HistoryBody(state: state)),
                const SizedBox(height: AppDimens.md),
                _HistoryTotal(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<T?> showMohsenHistoryBottomSheet<T>(
  BuildContext context, {
  required String committeeId,
  required String memberId,
  MohsensRepository? repository,
  VoidCallback? onAdd,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) =>
          HistoryCubit(repository: repository ?? FirestoreMohsensRepository())
            ..loadHistory(committeeId: committeeId, uid: memberId),
      child: MohsenHistoryBottomSheet(onAdd: onAdd),
    ),
  );
}

class _HistoryBody extends StatelessWidget {
  final HistoryState state;

  const _HistoryBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is HistoryInitial || state is HistoryLoading) {
      return const LoadingWidget();
    }

    if (state is HistoryEmpty) {
      return const EmptyStateWidget(
        message: 'No history yet',
        icon: Icons.history,
      );
    }

    if (state case HistoryError(message: final message)) {
      return AppErrorWidget(
        message: message,
        onRetry: () => context.read<HistoryCubit>().reloadHistory(),
      );
    }

    final success = state as HistorySuccess;
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.only(bottom: AppDimens.sm),
          itemCount: success.entries.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppDimens.sm),
          itemBuilder: (context, index) {
            final entry = success.entries[index];
            return HistoryEntryCard(
              value: entry.value,
              description: entry.reason,
              date: DateTimeHelper.formatDateTime(entry.createdAt),
              onEdit: success.isProcessing
                  ? null
                  : () => _showEditSheet(context, entry),
              onDelete: success.isProcessing
                  ? null
                  : () => _confirmDelete(context, entry),
            );
          },
        ),
        if (success.isProcessing)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33FFFFFF),
              child: LoadingWidget(size: 28),
            ),
          ),
      ],
    );
  }

  Future<void> _showEditSheet(BuildContext context, MohsenEntryModel entry) {
    final cubit = context.read<HistoryCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: _EditMohsenSheet(entry: entry, cubit: cubit),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    MohsenEntryModel entry,
  ) async {
    final cubit = context.read<HistoryCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deleteEntry(entry.id);
    }
  }
}

class _HistoryTotal extends StatelessWidget {
  final HistoryState state;

  const _HistoryTotal({required this.state});

  @override
  Widget build(BuildContext context) {
    final total = state is HistorySuccess ? (state as HistorySuccess).total : 0;
    final formattedTotal = total % 1 == 0
        ? total.toInt().toString()
        : total.toString();

    return Row(
      children: [
        Text('Total Mohsens', style: AppTextStyles.bodyBold),
        const Spacer(),
        Text(
          formattedTotal,
          style: AppTextStyles.statNumber(
            color: AppColors.secondary,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

class _EditMohsenSheet extends StatefulWidget {
  final MohsenEntryModel entry;
  final HistoryCubit cubit;

  const _EditMohsenSheet({required this.entry, required this.cubit});

  @override
  State<_EditMohsenSheet> createState() => _EditMohsenSheetState();
}

class _EditMohsenSheetState extends State<_EditMohsenSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueController;
  late final TextEditingController _reasonController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.entry.value.toString(),
    );
    _reasonController = TextEditingController(text: widget.entry.reason);
  }

  @override
  void dispose() {
    _valueController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      cancelText: 'Cancel',
      doneText: 'Save',
      isLoading: _isSaving,
      onCancel: _isSaving ? () {} : () => Navigator.of(context).pop(),
      onDone: _isSaving ? () {} : _save,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Mohsen', style: AppTextStyles.heading1),
            const SizedBox(height: AppDimens.lg),
            AppTextField(
              label: 'Value',
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              validator: (value) {
                final number = num.tryParse(value?.trim() ?? '');
                if (number == null || number <= 0) {
                  return 'Enter a value greater than zero';
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimens.md),
            AppTextField(
              label: 'Reason',
              controller: _reasonController,
              maxLines: 3,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Reason is required'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final saved = await widget.cubit.updateEntry(
      entryId: widget.entry.id,
      newValue: num.parse(_valueController.text.trim()),
      newReason: _reasonController.text,
    );

    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _isSaving = false);
    }
  }
}
