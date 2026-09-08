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
  // Create
  // ---------------------------------------------------------------------------

  /// Adds a new personal note with the given [title] and [content].
  ///
  /// The stream subscription will automatically emit the updated list once
  /// Firestore confirms the write, so no manual state update is needed here
  /// beyond error handling.
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    try {
      await _notesService.addNote(title: title, content: content);
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  /// Updates an existing note (e.g. title or content change).
  Future<void> updateNote(NoteModel note) async {
    try {
      await _notesService.updateNote(note);
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Toggles the `isDone` flag on a note identified by [noteId].
  Future<void> toggleNoteDone({
    required String noteId,
    required bool isDone,
  }) async {
    try {
      await _notesService.toggleNoteDone(noteId: noteId, isDone: isDone);
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------

  /// Deletes a note by its [noteId].
  Future<void> deleteNote(String noteId) async {
    try {
      await _notesService.deleteNote(noteId);
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: e.toString(),
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
