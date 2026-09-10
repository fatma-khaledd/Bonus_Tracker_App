import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/models.dart';
import '../../../shared/repositories/mohsens/mohsens_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final MohsensRepository repository;

  HistoryCubit({required this.repository}) : super(const HistoryInitial());

  Future<void> loadHistory({
    required String committeeId,
    required String uid,
  }) async {
    emit(const HistoryLoading());

    try {
      final entries = await repository.getMohsensHistory(
        committeeId: committeeId,
        uid: uid,
      );

      if (entries.isEmpty) {
        emit(const HistoryEmpty());
      } else {
        emit(HistorySuccess(entries));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void updateEntry({
    required String entryId,
    required num newValue,
    required String newReason,
  }) {
    final currentState = state;

    if (currentState is! HistorySuccess) {
      return;
    }

    final updatedEntries = currentState.entries.map((entry) {
      if (entry.id != entryId) {
        return entry;
      }

      return entry.copyWith(
        value: newValue,
        reason: newReason,
        updatedAt: DateTime.now(),
      );
    }).toList();

    emit(HistorySuccess(updatedEntries));
  }

  void deleteEntry(String entryId) {
    final currentState = state;

    if (currentState is! HistorySuccess) {
      return;
    }

    final updatedEntries = currentState.entries
        .where((entry) => entry.id != entryId)
        .toList();

    if (updatedEntries.isEmpty) {
      emit(const HistoryEmpty());
    } else {
      emit(HistorySuccess(updatedEntries));
    }
  }
}
