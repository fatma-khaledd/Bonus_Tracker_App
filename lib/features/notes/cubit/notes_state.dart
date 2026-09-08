import '../../../shared/models/models.dart';

/// Possible statuses for the notes feature.
enum NotesStatus {
  /// Initial state before any data has been requested.
  initial,

  /// A load or mutation operation is in progress.
  loading,

  /// Notes have been loaded successfully.
  success,

  /// An error occurred during a load or mutation.
  error,
}

/// Immutable state for [NotesCubit].
class NotesState {
  final NotesStatus status;
  final List<NoteModel> notes;
  final String? errorMessage;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage,
  });

  /// Whether the notes list is empty while in a success state.
  bool get isEmpty => status == NotesStatus.success && notes.isEmpty;

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// - If [errorMessage] is provided, it replaces the current error message.
  /// - If [clearError] is true, [errorMessage] is reset to `null`.
  /// - Otherwise, the existing [errorMessage] is preserved.
  NotesState copyWith({
    NotesStatus? status,
    List<NoteModel>? notes,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          notes == other.notes &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      status.hashCode ^ notes.hashCode ^ errorMessage.hashCode;

  @override
  String toString() =>
      'NotesState(status: $status, notes: ${notes.length}, errorMessage: $errorMessage)';
}
