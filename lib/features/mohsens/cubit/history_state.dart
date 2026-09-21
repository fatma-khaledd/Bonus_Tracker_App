import '../../../shared/models/models.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistorySuccess extends HistoryState {
  final List<MohsenEntryModel> entries;
  final bool isProcessing;
  final String? actionError;

  HistorySuccess(
    List<MohsenEntryModel> entries, {
    this.isProcessing = false,
    this.actionError,
  }) : entries = List.unmodifiable(entries);

  num get total {
    return entries.fold(0, (total, entry) => total + entry.value);
  }
}

class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
}
