import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../../shared/models/models.dart';

/// Service responsible for all Firestore CRUD operations on personal notes.
///
/// Follows the project's architecture: UI → Cubit → **Service** → Firebase.
/// No UI or state-management logic lives here — only Firebase-specific code.
class NotesService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the currently authenticated user's UID.
  ///
  /// Throws a [StateError] if no user is signed in.
  String get _currentUid {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user found.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      _firestore.collection(FirestorePaths.notes());

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Watches all personal notes belonging to the current user.
  ///
  /// Returns a real-time [Stream] sorted by `createdAt` descending (newest first).
  ///
  /// Note: We query by `ownerId` and `type` (equality filters supported by
  /// automatic single-field indexes) and sort in memory. This eliminates the
  /// need for any composite index in Firestore and avoids runtime `failed-precondition` errors.
  Stream<List<NoteModel>> watchPersonalNotes() {
    return _notesCollection
        .where('ownerId', isEqualTo: _currentUid)
        .where('type', isEqualTo: NoteType.personal.value)
        .snapshots()
        .map((snapshot) {
          final notes = snapshot.docs
              .map((doc) => NoteModel.fromMap(doc.data(), id: doc.id))
              .toList();
          notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return notes;
        });
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  /// Adds a new personal note for the current user.
  ///
  /// Uses [FieldValue.serverTimestamp] for `createdAt` and `updatedAt` so that
  /// timestamps are consistent across devices.
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final docRef = _notesCollection.doc();

    final note = NoteModel(
      id: docRef.id,
      ownerId: _currentUid,
      type: NoteType.personal,
      title: title,
      content: content,
      createdAt: DateTime.now(), // placeholder — overridden below
      updatedAt: DateTime.now(), // placeholder — overridden below
    );

    final data = note.toMap();
    // Override with server timestamps for consistency.
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
  }

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  /// Updates an existing note (title, content, or any other field).
  ///
  /// Automatically refreshes `updatedAt` with a server timestamp.
  Future<void> updateNote(NoteModel note) async {
    final data = note.toMap();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.doc(FirestorePaths.note(note.id)).update(data);
  }

  /// Toggles the `isDone` flag on a note.
  Future<void> toggleNoteDone({
    required String noteId,
    required bool isDone,
  }) async {
    await _firestore.doc(FirestorePaths.note(noteId)).update({
      'isDone': isDone,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------

  /// Permanently deletes a note by its [noteId].
  Future<void> deleteNote(String noteId) async {
    await _firestore.doc(FirestorePaths.note(noteId)).delete();
  }
}
