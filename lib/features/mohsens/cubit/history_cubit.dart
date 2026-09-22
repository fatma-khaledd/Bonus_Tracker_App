import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/repositories/mohsens/mohsens_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final MohsensRepository repository;
  String? _committeeId;
  String? _memberId;

  HistoryCubit({required this.repository}) : super(const HistoryInitial());

  Future<void> loadHistory({
    required String committeeId,
    required String uid,
  }) async {
    _committeeId = committeeId;
    _memberId = uid;
    emit(const HistoryLoading());

    try {
      final entries = await repository.getMohsensHistory(
        committeeId: committeeId,
        uid: uid,
      );
      if (isClosed) return;

      if (entries.isEmpty) {
        emit(const HistoryEmpty());
      } else {
        emit(HistorySuccess(entries));
      }
    } catch (e) {
      if (isClosed) return;
      emit(HistoryError(_errorMessage(e)));
    }
  }

  Future<void> reloadHistory() async {
    final committeeId = _committeeId;
    final memberId = _memberId;
    if (committeeId == null || memberId == null) return;

    await loadHistory(committeeId: committeeId, uid: memberId);
  }

  Future<bool> updateEntry({
    required String entryId,
    required num newValue,
    required String newReason,
  }) async {
    final currentState = state;
    final committeeId = _committeeId;
    final memberId = _memberId;

    if (currentState is! HistorySuccess ||
        currentState.isProcessing ||
        committeeId == null ||
        memberId == null) {
      return false;
    }

    final reason = newReason.trim();
    if (newValue <= 0 || reason.isEmpty) return false;

    final entryIndex = currentState.entries.indexWhere(
      (entry) => entry.id == entryId,
    );
    if (entryIndex == -1) return false;

    final updatedEntry = currentState.entries[entryIndex].copyWith(
      value: newValue,
      reason: reason,
      updatedAt: DateTime.now(),
    );

    emit(HistorySuccess(currentState.entries, isProcessing: true));

    try {
      await repository.updateMohsenEntry(
        committeeId: committeeId,
        memberId: memberId,
        entry: updatedEntry,
      );
      if (isClosed) return true;

      final updatedEntries = [...currentState.entries];
      updatedEntries[entryIndex] = updatedEntry;
      emit(HistorySuccess(updatedEntries));
      return true;
    } catch (e) {
      if (isClosed) return false;
      emit(HistorySuccess(currentState.entries, actionError: _errorMessage(e)));
      return false;
    }
  }

  Future<bool> deleteEntry(String entryId) async {
    final currentState = state;
    final committeeId = _committeeId;
    final memberId = _memberId;

    if (currentState is! HistorySuccess ||
        currentState.isProcessing ||
        committeeId == null ||
        memberId == null) {
      return false;
    }

    if (!currentState.entries.any((entry) => entry.id == entryId)) {
      return false;
    }

    emit(HistorySuccess(currentState.entries, isProcessing: true));

    try {
      await repository.deleteMohsenEntry(
        committeeId: committeeId,
        memberId: memberId,
        entryId: entryId,
      );
      if (isClosed) return true;

      final updatedEntries = currentState.entries
          .where((entry) => entry.id != entryId)
          .toList();

      if (updatedEntries.isEmpty) {
        emit(const HistoryEmpty());
      } else {
        emit(HistorySuccess(updatedEntries));
      }
      return true;
    } catch (e) {
      if (isClosed) return false;
      emit(HistorySuccess(currentState.entries, actionError: _errorMessage(e)));
      return false;
    }
  }

  String _errorMessage(Object error) {
    final message = error.toString();
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }
}
