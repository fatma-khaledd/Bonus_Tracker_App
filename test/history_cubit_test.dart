import 'dart:async';

import 'package:bonus_tracker_app/features/mohsens/cubit/history_cubit.dart';
import 'package:bonus_tracker_app/features/mohsens/cubit/history_state.dart';
import 'package:bonus_tracker_app/features/mohsens/widgets/mohsen_history_bottom_sheet.dart';
import 'package:bonus_tracker_app/shared/models/models.dart';
import 'package:bonus_tracker_app/shared/repositories/mohsens/mohsens_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeMohsensRepository implements MohsensRepository {
  final List<MohsenEntryModel> entries;
  Object? failure;
  Completer<void>? updateCompleter;

  FakeMohsensRepository({List<MohsenEntryModel>? entries})
    : entries = [...?entries];

  @override
  Future<List<MohsenEntryModel>> getMohsensHistory({
    required String committeeId,
    required String uid,
  }) async {
    if (failure case final error?) throw error;
    return entries
        .where(
          (entry) => entry.committeeId == committeeId && entry.memberId == uid,
        )
        .toList();
  }

  @override
  Future<void> addMohsenEntry({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel entry,
    required String actorName,
    required String actorRole,
    String? notificationTitle,
    String? notificationMessage,
  }) async {
    entries.add(entry);
  }

  @override
  Future<void> updateMohsenEntry({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel entry,
  }) async {
    await updateCompleter?.future;
    if (failure case final error?) throw error;
    final index = entries.indexWhere((item) => item.id == entry.id);
    if (index == -1) throw StateError('Entry not found');
    entries[index] = entry;
  }

  @override
  Future<void> deleteMohsenEntry({
    required String committeeId,
    required String memberId,
    required String entryId,
  }) async {
    if (failure case final error?) throw error;
    entries.removeWhere((entry) => entry.id == entryId);
  }
}

MohsenEntryModel _entry({String id = 'e1', num value = 2}) {
  final timestamp = DateTime(2026, 9, 18, 10, 30);
  return MohsenEntryModel(
    id: id,
    memberId: 'member-1',
    committeeId: 'committee-1',
    type: MohsenType.mohsen,
    value: value,
    reason: 'Helpful teammate',
    addedBy: 'admin-1',
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

void main() {
  group('HistoryCubit', () {
    test('loads matching history and calculates the total', () async {
      final repository = FakeMohsensRepository(
        entries: [
          _entry(),
          _entry(id: 'e2', value: 3),
        ],
      );
      final cubit = HistoryCubit(repository: repository);
      addTearDown(cubit.close);

      await cubit.loadHistory(committeeId: 'committee-1', uid: 'member-1');

      expect(cubit.state, isA<HistorySuccess>());
      expect((cubit.state as HistorySuccess).total, 5);
    });

    test('persists edits before updating the visible history', () async {
      final repository = FakeMohsensRepository(entries: [_entry()]);
      final cubit = HistoryCubit(repository: repository);
      addTearDown(cubit.close);
      await cubit.loadHistory(committeeId: 'committee-1', uid: 'member-1');

      final saved = await cubit.updateEntry(
        entryId: 'e1',
        newValue: 4,
        newReason: '  Excellent support  ',
      );

      expect(saved, isTrue);
      expect(repository.entries.single.value, 4);
      expect(repository.entries.single.reason, 'Excellent support');
      final state = cubit.state as HistorySuccess;
      expect(state.entries.single.value, 4);
      expect(state.total, 4);
    });

    test('keeps the previous list when an edit fails', () async {
      final repository = FakeMohsensRepository(entries: [_entry()]);
      final cubit = HistoryCubit(repository: repository);
      addTearDown(cubit.close);
      await cubit.loadHistory(committeeId: 'committee-1', uid: 'member-1');
      repository.failure = Exception('Could not save');

      final saved = await cubit.updateEntry(
        entryId: 'e1',
        newValue: 8,
        newReason: 'Changed reason',
      );

      expect(saved, isFalse);
      final state = cubit.state as HistorySuccess;
      expect(state.entries.single.value, 2);
      expect(state.actionError, 'Could not save');
    });

    test('persists deletion and emits empty for the last entry', () async {
      final repository = FakeMohsensRepository(entries: [_entry()]);
      final cubit = HistoryCubit(repository: repository);
      addTearDown(cubit.close);
      await cubit.loadHistory(committeeId: 'committee-1', uid: 'member-1');

      final deleted = await cubit.deleteEntry('e1');

      expect(deleted, isTrue);
      expect(repository.entries, isEmpty);
      expect(cubit.state, isA<HistoryEmpty>());
    });

    test('does not emit after being closed during an edit', () async {
      final completer = Completer<void>();
      final repository = FakeMohsensRepository(entries: [_entry()])
        ..updateCompleter = completer;
      final cubit = HistoryCubit(repository: repository);
      await cubit.loadHistory(committeeId: 'committee-1', uid: 'member-1');

      final update = cubit.updateEntry(
        entryId: 'e1',
        newValue: 3,
        newReason: 'Updated',
      );
      await cubit.close();
      completer.complete();

      await expectLater(update, completion(isTrue));
    });
  });

  test('DateTimeHelper formats history timestamps for display', () {
    expect(
      DateTimeHelper.formatDateTime(DateTime(2026, 8, 19, 10, 30)),
      '19/08/2026 • 10:30',
    );
  });

  testWidgets('edit form saves the user supplied value and reason', (
    tester,
  ) async {
    final repository = FakeMohsensRepository(entries: [_entry()]);
    final cubit = HistoryCubit(repository: repository);
    addTearDown(cubit.close);
    await cubit.loadHistory(committeeId: 'committee-1', uid: 'member-1');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const MohsenHistoryBottomSheet(),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '4.5');
    await tester.enterText(fields.at(1), 'User supplied reason');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repository.entries.single.value, 4.5);
    expect(repository.entries.single.reason, 'User supplied reason');
  });
}
