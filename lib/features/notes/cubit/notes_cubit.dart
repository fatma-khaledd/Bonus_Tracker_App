import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/models.dart';
import '../services/notes_service.dart';
import 'notes_state.dart';

/// Cubit that manages the state for the Personal Notes feature.
///
/// Architecture flow:
/// ```
/// NotesScreen → NotesCubit → NotesService → Firestore
/// ```
///
/// The cubit subscribes to a real-time Firestore stream so that the UI
/// automatically reflects any changes (add / update / delete) without manual
/// refreshes.
class NotesCubit extends Cubit<NotesState> {
  final NotesService _notesService;
  StreamSubscription<List<NoteModel>>? _notesSubscription;

  NotesCubit({
    required this._notesService,
  }) : super(const NotesState());

  // ---------------------------------------------------------------------------
  // Load / Watch
  // ---------------------------------------------------------------------------

  /// Starts watching the current user's personal notes.
  ///
  /// Emits [NotesStatus.loading] immediately, then [NotesStatus.success]
  /// every time Firestore delivers a new snapshot, or [NotesStatus.error]
  /// if the stream errors out.
  void loadNotes() {
    emit(state.copyWith(status: NotesStatus.loading, clearError: true));

    // Cancel any previous subscription to avoid duplicates.
    _notesSubscription?.cancel();

    _notesSubscription = _notesService.watchPersonalNotes().listen(
      (notes) {
        emit(state.copyWith(
          status: NotesStatus.success,
          notes: notes,
          clearError: true,
        ));
      },
      onError: (Object error) {
        emit(state.copyWith(
          status: NotesStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Action Status Management
  // ---------------------------------------------------------------------------

  /// Resets the action status back to [NotesActionStatus.initial].
  ///
  /// Typically called by the UI after handling an action event (e.g. after
  /// closing a bottom sheet or displaying a SnackBar).
  void resetActionStatus() {
    emit(state.copyWith(
      actionStatus: NotesActionStatus.initial,
      clearActionType: true,
      clearActionError: true,
    ));
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  /// Adds a new personal note with the given [title] and [content].
  ///
  /// Emits [NotesActionStatus.submitting], then [NotesActionStatus.success] on
  /// success, or [NotesActionStatus.error] on failure.
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    emit(state.copyWith(
      actionStatus: NotesActionStatus.submitting,
      actionType: NotesActionType.add,
      clearActionError: true,
      clearError: true,
    ));

    try {
      await _notesService.addNote(title: title, content: content);
      emit(state.copyWith(
        actionStatus: NotesActionStatus.success,
        actionType: NotesActionType.add,
        clearActionError: true,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        actionStatus: NotesActionStatus.error,
        actionType: NotesActionType.add,
        actionErrorMessage: e.toString(),
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  /// Updates an existing note (e.g. title or content change).
  ///
  /// Emits [NotesActionStatus.submitting], then [NotesActionStatus.success] on
  /// success, or [NotesActionStatus.error] on failure.
  Future<void> updateNote(NoteModel note) async {
    emit(state.copyWith(
      actionStatus: NotesActionStatus.submitting,
      actionType: NotesActionType.update,
      clearActionError: true,
      clearError: true,
    ));

    try {
      await _notesService.updateNote(note);
      emit(state.copyWith(
        actionStatus: NotesActionStatus.success,
        actionType: NotesActionType.update,
        clearActionError: true,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        actionStatus: NotesActionStatus.error,
        actionType: NotesActionType.update,
        actionErrorMessage: e.toString(),
      ));
    }
  }

  /// Toggles the `isDone` flag on a note identified by [noteId].
  ///
  /// Emits [NotesActionStatus.submitting], then [NotesActionStatus.success] on
  /// success, or [NotesActionStatus.error] on failure.
  Future<void> toggleNoteDone({
    required String noteId,
    required bool isDone,
  }) async {
    emit(state.copyWith(
      actionStatus: NotesActionStatus.submitting,
      actionType: NotesActionType.toggleDone,
      clearActionError: true,
      clearError: true,
    ));

    try {
      await _notesService.toggleNoteDone(noteId: noteId, isDone: isDone);
      emit(state.copyWith(
        actionStatus: NotesActionStatus.success,
        actionType: NotesActionType.toggleDone,
        clearActionError: true,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        actionStatus: NotesActionStatus.error,
        actionType: NotesActionType.toggleDone,
        actionErrorMessage: e.toString(),
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------

  /// Deletes a note by its [noteId].
  ///
  /// Emits [NotesActionStatus.submitting], then [NotesActionStatus.success] on
  /// success, or [NotesActionStatus.error] on failure.
  Future<void> deleteNote(String noteId) async {
    emit(state.copyWith(
      actionStatus: NotesActionStatus.submitting,
      actionType: NotesActionType.delete,
      clearActionError: true,
      clearError: true,
    ));

    try {
      await _notesService.deleteNote(noteId);
      emit(state.copyWith(
        actionStatus: NotesActionStatus.success,
        actionType: NotesActionType.delete,
        clearActionError: true,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        actionStatus: NotesActionStatus.error,
        actionType: NotesActionType.delete,
        actionErrorMessage: e.toString(),
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
