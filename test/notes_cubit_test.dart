import 'dart:async';

import 'package:bonus_tracker_app/features/notes/notes.dart';
import 'package:bonus_tracker_app/shared/models/models.dart';
import 'package:bonus_tracker_app/shared/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotesRepository implements NotesRepository {
  final StreamController<List<NoteModel>> notesController =
      StreamController<List<NoteModel>>.broadcast();

  Completer<void>? pendingMutation;
  bool shouldThrow = false;
  bool shouldThrowSyncOnWatch = false;
  String? lastAddedTitle;
  String? lastAddedContent;
  String? lastAddedOwnerId;
  NoteModel? lastUpdatedNote;
  String? lastToggledId;
  bool? lastToggledDone;
  String? lastDeletedId;

  @override
  Stream<List<NoteModel>> watchPersonalNotes({String? uid}) {
    if (shouldThrowSyncOnWatch) {
      throw StateError('No authenticated user found.');
    }
    return notesController.stream;
  }

  @override
  Future<void> addNote({
    required String title,
    required String content,
    String? ownerId,
  }) async {
    if (pendingMutation != null) await pendingMutation!.future;
    if (shouldThrow) throw Exception('Failed to add note');
    lastAddedTitle = title;
    lastAddedContent = content;
    lastAddedOwnerId = ownerId;
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    if (pendingMutation != null) await pendingMutation!.future;
    if (shouldThrow) throw Exception('Failed to update note');
    lastUpdatedNote = note;
  }

  @override
  Future<void> toggleNoteDone({
    required String noteId,
    required bool isDone,
  }) async {
    if (pendingMutation != null) await pendingMutation!.future;
    if (shouldThrow) throw Exception('Failed to toggle note');
    lastToggledId = noteId;
    lastToggledDone = isDone;
  }

  @override
  Future<void> deleteNote(String noteId) async {
    if (pendingMutation != null) await pendingMutation!.future;
    if (shouldThrow) throw Exception('Failed to delete note');
    lastDeletedId = noteId;
  }

  Future<void> dispose() => notesController.close();
}

void main() {
  group('NotesCubit', () {
    late FakeNotesRepository fakeNotesRepository;
    late NotesCubit notesCubit;

    setUp(() {
      fakeNotesRepository = FakeNotesRepository();
      notesCubit = NotesCubit(notesRepository: fakeNotesRepository);
    });

    tearDown(() async {
      if (!notesCubit.isClosed) await notesCubit.close();
      await fakeNotesRepository.dispose();
    });

    final note = NoteModel(
      id: 'n1',
      ownerId: 'user1',
      type: NoteType.personal,
      title: 'Title',
      content: 'Content',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
    final actions = <NotesActionType, Future<void> Function(NotesCubit)>{
      NotesActionType.add: (cubit) =>
          cubit.addNote(title: 'Title', content: 'Content'),
      NotesActionType.update: (cubit) => cubit.updateNote(note),
      NotesActionType.toggleDone: (cubit) =>
          cubit.toggleNoteDone(noteId: 'n1', isDone: true),
      NotesActionType.delete: (cubit) => cubit.deleteNote('n1'),
    };

    for (final action in actions.entries) {
      for (final fails in [false, true]) {
        test(
          '${action.key.name} completes safely after close (fails: $fails)',
          () async {
            final pending = Completer<void>();
            fakeNotesRepository.pendingMutation = pending;
            final operation = action.value(notesCubit);
            final completion = expectLater(operation, completes);
            expect(notesCubit.state.actionStatus, NotesActionStatus.submitting);
            expect(notesCubit.state.actionType, action.key);
            await notesCubit.close();
            final closedState = notesCubit.state;

            if (fails) {
              pending.completeError(StateError('Delayed write failure'));
            } else {
              pending.complete();
            }
            await completion;
            expect(notesCubit.state, same(closedState));
          },
        );
      }

      test('${action.key.name} reports failure while open', () async {
        fakeNotesRepository.shouldThrow = true;
        await action.value(notesCubit);
        expect(notesCubit.state.actionStatus, NotesActionStatus.error);
        expect(notesCubit.state.actionType, action.key);
        expect(notesCubit.state.actionErrorMessage, contains('Failed to'));
      });
    }

    test('close cancels the notes subscription', () async {
      notesCubit.loadNotes();
      expect(fakeNotesRepository.notesController.hasListener, isTrue);
      await notesCubit.close();
      expect(fakeNotesRepository.notesController.hasListener, isFalse);
      final closedState = notesCubit.state;
      fakeNotesRepository.notesController.add([note]);
      await Future<void>.delayed(Duration.zero);
      expect(notesCubit.state, same(closedState));
    });

    test('initial state has initial status and actionStatus', () {
      expect(notesCubit.state.status, equals(NotesStatus.initial));
      expect(notesCubit.state.actionStatus, equals(NotesActionStatus.initial));
      expect(notesCubit.state.notes, isEmpty);
      expect(notesCubit.state.isSubmitting, isFalse);
    });

    test('loadNotes emits loading then success with notes', () async {
      final sampleNotes = [
        NoteModel(
          id: '1',
          ownerId: 'user1',
          type: NoteType.personal,
          title: 'Title',
          content: 'Content',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      notesCubit.loadNotes();
      expect(notesCubit.state.status, equals(NotesStatus.loading));

      fakeNotesRepository.notesController.add(sampleNotes);
      await Future<void>.delayed(Duration.zero);

      expect(notesCubit.state.status, equals(NotesStatus.success));
      expect(notesCubit.state.notes, equals(sampleNotes));
    });

    test(
      'loadNotes transitions to NotesStatus.error on stream error',
      () async {
        notesCubit.loadNotes();
        expect(notesCubit.state.status, equals(NotesStatus.loading));

        fakeNotesRepository.notesController.addError(
          Exception('Firestore stream error'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(notesCubit.state.status, equals(NotesStatus.error));
        expect(
          notesCubit.state.errorMessage,
          contains('Firestore stream error'),
        );
      },
    );

    test(
      'loadNotes emits NotesStatus.error when watchPersonalNotes throws synchronously',
      () {
        fakeNotesRepository.shouldThrowSyncOnWatch = true;

        notesCubit.loadNotes();

        expect(notesCubit.state.status, equals(NotesStatus.error));
        expect(
          notesCubit.state.errorMessage,
          contains('No authenticated user found.'),
        );
      },
    );

    test('addNote emits submitting then success on success', () async {
      final states = <NotesState>[];
      final subscription = notesCubit.stream.listen(states.add);

      await notesCubit.addNote(title: 'New Note', content: 'New Content');
      await Future<void>.delayed(Duration.zero);

      expect(fakeNotesRepository.lastAddedTitle, 'New Note');
      expect(fakeNotesRepository.lastAddedContent, 'New Content');

      expect(states.length, 2);
      expect(states[0].actionStatus, NotesActionStatus.submitting);
      expect(states[0].actionType, NotesActionType.add);
      expect(states[0].isSubmitting, isTrue);

      expect(states[1].actionStatus, NotesActionStatus.success);
      expect(states[1].actionType, NotesActionType.add);
      expect(states[1].isActionSuccess, isTrue);

      await subscription.cancel();
    });

    test('addNote emits submitting then error on failure', () async {
      fakeNotesRepository.shouldThrow = true;
      final states = <NotesState>[];
      final subscription = notesCubit.stream.listen(states.add);

      await notesCubit.addNote(title: 'Fail Note', content: 'Fail Content');
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].actionStatus, NotesActionStatus.submitting);
      expect(states[1].actionStatus, NotesActionStatus.error);
      expect(states[1].actionType, NotesActionType.add);
      expect(states[1].isActionError, isTrue);
      expect(states[1].actionErrorMessage, contains('Failed to add note'));

      await subscription.cancel();
    });

    test('updateNote emits submitting then success', () async {
      final note = NoteModel(
        id: '1',
        ownerId: 'user1',
        type: NoteType.personal,
        title: 'Updated',
        content: 'Updated content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final states = <NotesState>[];
      final subscription = notesCubit.stream.listen(states.add);

      await notesCubit.updateNote(note);
      await Future<void>.delayed(Duration.zero);

      expect(fakeNotesRepository.lastUpdatedNote, note);
      expect(states.length, 2);
      expect(states[0].actionStatus, NotesActionStatus.submitting);
      expect(states[0].actionType, NotesActionType.update);
      expect(states[1].actionStatus, NotesActionStatus.success);
      expect(states[1].actionType, NotesActionType.update);

      await subscription.cancel();
    });

    test('toggleNoteDone emits submitting then success', () async {
      final states = <NotesState>[];
      final subscription = notesCubit.stream.listen(states.add);

      await notesCubit.toggleNoteDone(noteId: 'n1', isDone: true);
      await Future<void>.delayed(Duration.zero);

      expect(fakeNotesRepository.lastToggledId, 'n1');
      expect(fakeNotesRepository.lastToggledDone, isTrue);
      expect(states.length, 2);
      expect(states[0].actionStatus, NotesActionStatus.submitting);
      expect(states[0].actionType, NotesActionType.toggleDone);
      expect(states[1].actionStatus, NotesActionStatus.success);
      expect(states[1].actionType, NotesActionType.toggleDone);

      await subscription.cancel();
    });

    test('deleteNote emits submitting then success', () async {
      final states = <NotesState>[];
      final subscription = notesCubit.stream.listen(states.add);

      await notesCubit.deleteNote('n1');
      await Future<void>.delayed(Duration.zero);

      expect(fakeNotesRepository.lastDeletedId, 'n1');
      expect(states.length, 2);
      expect(states[0].actionStatus, NotesActionStatus.submitting);
      expect(states[0].actionType, NotesActionType.delete);
      expect(states[1].actionStatus, NotesActionStatus.success);
      expect(states[1].actionType, NotesActionType.delete);

      await subscription.cancel();
    });

    test(
      'resetActionStatus resets actionStatus, actionType, actionError',
      () async {
        fakeNotesRepository.shouldThrow = true;
        await notesCubit.addNote(title: 'Fail', content: 'Fail');
        await Future<void>.delayed(Duration.zero);
        expect(notesCubit.state.actionStatus, NotesActionStatus.error);

        notesCubit.resetActionStatus();
        expect(notesCubit.state.actionStatus, NotesActionStatus.initial);
        expect(notesCubit.state.actionType, isNull);
        expect(notesCubit.state.actionErrorMessage, isNull);
      },
    );

    test(
      'subsequent successful action clears previous error and actionError',
      () async {
        // 1. Fail first
        fakeNotesRepository.shouldThrow = true;
        await notesCubit.addNote(title: 'Fail', content: 'Fail');
        await Future<void>.delayed(Duration.zero);
        expect(notesCubit.state.isActionError, isTrue);
        expect(notesCubit.state.actionErrorMessage, isNotNull);

        // 2. Now succeed
        fakeNotesRepository.shouldThrow = false;
        await notesCubit.addNote(title: 'Success', content: 'Content');
        await Future<void>.delayed(Duration.zero);

        expect(notesCubit.state.isActionSuccess, isTrue);
        expect(notesCubit.state.actionErrorMessage, isNull);
        expect(notesCubit.state.errorMessage, isNull);
      },
    );

    test(
      'copyWith automatically clears errorMessage when transitioning to non-error status',
      () {
        const errorState = NotesState(
          status: NotesStatus.error,
          errorMessage: 'Network failed',
          actionStatus: NotesActionStatus.error,
          actionErrorMessage: 'Action failed',
        );

        final successState = errorState.copyWith(status: NotesStatus.success);
        expect(successState.errorMessage, isNull);

        final actionSuccessState = errorState.copyWith(
          actionStatus: NotesActionStatus.success,
        );
        expect(actionSuccessState.actionErrorMessage, isNull);

        final actionSubmittingState = errorState.copyWith(
          actionStatus: NotesActionStatus.submitting,
        );
        expect(actionSubmittingState.actionErrorMessage, isNull);
      },
    );

    test('NotesState equality uses listEquals for notes list', () {
      final sampleNote = NoteModel(
        id: '1',
        ownerId: 'user1',
        type: NoteType.personal,
        title: 'Title',
        content: 'Content',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      final stateA = NotesState(
        status: NotesStatus.success,
        notes: [sampleNote],
      );
      final stateB = NotesState(
        status: NotesStatus.success,
        notes: [sampleNote],
      );

      expect(identical(stateA.notes, stateB.notes), isFalse);
      expect(stateA, equals(stateB));
      expect(stateA.hashCode, equals(stateB.hashCode));
      expect({stateA}.contains(stateB), isTrue);
    });
  });
}
