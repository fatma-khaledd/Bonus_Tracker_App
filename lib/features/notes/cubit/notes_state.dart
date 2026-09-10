import '../../../shared/models/models.dart';

/// Possible statuses for the notes list.
enum NotesStatus {
  /// Initial state before any data has been requested.
  initial,

  /// Notes are currently loading from Firestore.
  loading,

  /// Notes have been loaded successfully.
  success,

  /// An error occurred during a load or stream watch.
  error,
}

/// Status of mutation actions (create, update, delete).
enum NotesActionStatus {
  /// Initial state when no action is running.
  initial,

  /// An action is currently in progress (e.g. saving, updating, deleting).
  submitting,

  /// The action completed successfully.
  success,

  /// The action failed with an error.
  error,
}

/// The specific mutation action being performed.
enum NotesActionType {
  /// Creating a new note.
  add,

  /// Updating an existing note.
  update,

  /// Toggling the done/completed status of a note.
  toggleDone,

  /// Deleting a note.
  delete,
}

/// Immutable state for [NotesCubit].
class NotesState {
  final NotesStatus status;
  final List<NoteModel> notes;
  final String? errorMessage;

  /// Status of the latest mutation action (add, update, delete).
  final NotesActionStatus actionStatus;

  /// The type of the latest mutation action.
  final NotesActionType? actionType;

  /// Error message if the mutation action failed.
  final String? actionErrorMessage;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage,
    this.actionStatus = NotesActionStatus.initial,
    this.actionType,
    this.actionErrorMessage,
  });

  /// Whether the notes list is empty while in a success state.
  bool get isEmpty => status == NotesStatus.success && notes.isEmpty;

  /// Whether a mutation action is currently in progress.
  bool get isSubmitting => actionStatus == NotesActionStatus.submitting;

  /// Whether the latest mutation action completed successfully.
  bool get isActionSuccess => actionStatus == NotesActionStatus.success;

  /// Whether the latest mutation action failed with an error.
  bool get isActionError => actionStatus == NotesActionStatus.error;

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// - If [errorMessage] is provided, it replaces the current error message.
  /// - If [clearError] is true, [errorMessage] is reset to `null`.
  /// - If [status] transitions to a non-error state and no [errorMessage] is
  ///   explicitly provided, [errorMessage] is automatically reset to `null`.
  /// - If [actionErrorMessage] is provided, it replaces the current action error.
  /// - If [clearActionError] is true, [actionErrorMessage] is reset to `null`.
  /// - If [actionStatus] transitions to a non-error state and no [actionErrorMessage]
  ///   is explicitly provided, [actionErrorMessage] is automatically reset to `null`.
  /// - If [clearActionType] is true, [actionType] is reset to `null`.
  NotesState copyWith({
    NotesStatus? status,
    List<NoteModel>? notes,
    String? errorMessage,
    bool clearError = false,
    NotesActionStatus? actionStatus,
    NotesActionType? actionType,
    bool clearActionType = false,
    String? actionErrorMessage,
    bool clearActionError = false,
  }) {
    final shouldClearError = clearError ||
        (status != null && status != NotesStatus.error && errorMessage == null);

    final shouldClearActionError = clearActionError ||
        (actionStatus != null &&
            actionStatus != NotesActionStatus.error &&
            actionErrorMessage == null);

    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: shouldClearError ? null : (errorMessage ?? this.errorMessage),
      actionStatus: actionStatus ?? this.actionStatus,
      actionType: clearActionType ? null : (actionType ?? this.actionType),
      actionErrorMessage: shouldClearActionError
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          notes == other.notes &&
          errorMessage == other.errorMessage &&
          actionStatus == other.actionStatus &&
          actionType == other.actionType &&
          actionErrorMessage == other.actionErrorMessage;

  @override
  int get hashCode =>
      status.hashCode ^
      notes.hashCode ^
      errorMessage.hashCode ^
      actionStatus.hashCode ^
      actionType.hashCode ^
      actionErrorMessage.hashCode;

  @override
  String toString() =>
      'NotesState(status: $status, notes: ${notes.length}, actionStatus: $actionStatus, actionType: $actionType, errorMessage: $errorMessage, actionErrorMessage: $actionErrorMessage)';
}
