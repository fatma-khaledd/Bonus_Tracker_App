import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'notes_repository.dart';

/// Firestore implementation of [NotesRepository].
class FirestoreNotesRepository implements NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreNotesRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String _resolveUid(String? uid) {
    if (uid != null && uid.isNotEmpty) return uid;
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw StateError('No authenticated user found.');
    }
    return currentUser.uid;
  }

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      _firestore.collection(FirestorePaths.notes());

  @override
  Stream<List<NoteModel>> watchPersonalNotes({String? uid}) {
    final targetUid = _resolveUid(uid);
    return _notesCollection
        .where('ownerId', isEqualTo: targetUid)
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

  @override
  Future<void> addNote({
    required String title,
    required String content,
    String? ownerId,
  }) async {
    final targetUid = _resolveUid(ownerId);
    final docRef = _notesCollection.doc();

    final note = NoteModel(
      id: docRef.id,
      ownerId: targetUid,
      type: NoteType.personal,
      title: title,
      content: content,
      createdAt: DateTime.now(), // placeholder — overridden below
      updatedAt: DateTime.now(), // placeholder — overridden below
    );

    final data = note.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final data = note.toMap();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.doc(FirestorePaths.note(note.id)).update(data);
  }

  @override
  Future<void> toggleNoteDone({
    required String noteId,
    required bool isDone,
  }) async {
    await _firestore.doc(FirestorePaths.note(noteId)).update({
      'isDone': isDone,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await _firestore.doc(FirestorePaths.note(noteId)).delete();
  }
}
