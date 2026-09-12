import '../../models/models.dart';

/// Contract definition for Personal & Committee Notes data operations.
abstract class NotesRepository {
  /// Watches all personal notes belonging to the specified user [uid].
  ///
  /// If [uid] is omitted, implementations should fall back to the currently
  /// signed-in user.
  Stream<List<NoteModel>> watchPersonalNotes({String? uid});

  /// Adds a new personal note.
  Future<void> addNote({
    required String title,
    required String content,
    String? ownerId,
  });

  /// Updates an existing note (e.g. title, content, or completion status).
  Future<void> updateNote(NoteModel note);

  /// Toggles the `isDone` flag on a note.
  Future<void> toggleNoteDone({
    required String noteId,
    required bool isDone,
  });

  /// Permanently deletes a note by its [noteId].
  Future<void> deleteNote(String noteId);
}
