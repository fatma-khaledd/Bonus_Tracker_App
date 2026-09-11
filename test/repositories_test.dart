import 'dart:async';

import 'package:bonus_tracker_app/shared/models/models.dart';
import 'package:bonus_tracker_app/shared/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

class MockMembersRepository implements MembersRepository {
  final List<MemberModel> members = [];
  bool markNotificationsSeenCalled = false;

  @override
  Future<List<MemberModel>> getMembersList(String committeeId) async {
    return members.where((m) => m.committeeId == committeeId).toList();
  }

  @override
  Future<MemberModel?> getMember({
    required String committeeId,
    required String uid,
  }) async {
    final matches = members.where(
      (m) => m.committeeId == committeeId && m.userId == uid,
    );
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<void> markNotificationsSeen({
    required String committeeId,
    required String uid,
  }) async {
    markNotificationsSeenCalled = true;
  }
}

class MockMohsensRepository implements MohsensRepository {
  final List<MohsenEntryModel> history = [];
  bool addMohsenCalled = false;

  @override
  Future<List<MohsenEntryModel>> getMohsensHistory({
    required String committeeId,
    required String uid,
  }) async {
    return history
        .where((e) => e.committeeId == committeeId && e.memberId == uid)
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
    addMohsenCalled = true;
    history.add(entry);
  }
}

class MockMeetingsRepository implements MeetingsRepository {
  MeetingModel? lastAddedMeeting;

  @override
  Future<void> addMeeting({
    required String committeeId,
    required MeetingModel meeting,
    required String actorName,
    required String actorRole,
    String? notificationTitle,
    String? notificationMessage,
  }) async {
    lastAddedMeeting = meeting;
  }
}

class MockEventsRepository implements EventsRepository {
  EventModel? lastAddedEvent;

  @override
  Future<void> addEvent({
    required String committeeId,
    required EventModel event,
    required String actorName,
    required String actorRole,
    String? notificationTitle,
    String? notificationMessage,
  }) async {
    lastAddedEvent = event;
  }
}

class MockNotificationsRepository implements NotificationsRepository {
  final StreamController<List<NotificationModel>> controller =
      StreamController<List<NotificationModel>>.broadcast();

  @override
  Stream<List<NotificationModel>> watchNotifications({
    required String committeeId,
    required String uid,
  }) {
    return controller.stream;
  }
}

class MockStatsRepository implements StatsRepository {
  MonthlyStatsModel? mockStats;
  List<SessionRecordModel> mockRecords = [];

  @override
  Future<MonthlyStatsModel?> getMemberMonthlyStats({
    required String committeeId,
    required String uid,
    required String monthKey,
  }) async {
    return mockStats;
  }

  @override
  Future<List<SessionRecordModel>> getSessionRecords({
    required String committeeId,
    required String uid,
  }) async {
    return mockRecords;
  }
}

void main() {
  group('Repository Interfaces & Polymorphism Tests', () {
    test('MembersRepository mock implementation fulfills contract', () async {
      final repo = MockMembersRepository();
      final member = MemberModel(
        userId: 'u1',
        displayName: 'Ali',
        committeeId: 'c1',
        role: MemberRole.member,
        joinedAt: DateTime(2026, 9, 1),
        stats: MemberStats(lastUpdatedAt: DateTime(2026, 9, 1)),
      );
      repo.members.add(member);

      final list = await repo.getMembersList('c1');
      expect(list.length, 1);
      expect(list.first.displayName, 'Ali');

      await repo.markNotificationsSeen(committeeId: 'c1', uid: 'u1');
      expect(repo.markNotificationsSeenCalled, isTrue);
    });

    test('MohsensRepository mock implementation fulfills contract', () async {
      final repo = MockMohsensRepository();
      final entry = MohsenEntryModel(
        id: 'e1',
        memberId: 'u1',
        committeeId: 'c1',
        type: MohsenType.mohsen,
        value: 5,
        reason: 'Excellent work',
        addedBy: 'admin1',
        createdAt: DateTime(2026, 9, 1),
        updatedAt: DateTime(2026, 9, 1),
      );

      await repo.addMohsenEntry(
        committeeId: 'c1',
        memberId: 'u1',
        entry: entry,
        actorName: 'Admin',
        actorRole: 'hr',
      );

      expect(repo.addMohsenCalled, isTrue);
      final history =
          await repo.getMohsensHistory(committeeId: 'c1', uid: 'u1');
      expect(history.length, 1);
      expect(history.first.reason, 'Excellent work');
    });

    test('MeetingsRepository mock implementation fulfills contract', () async {
      final repo = MockMeetingsRepository();
      final meeting = MeetingModel(
        id: 'm1',
        title: 'Weekly Sync',
        description: 'Sync meeting description',
        date: DateTime(2026, 9, 10),
        createdBy: 'u1',
        createdAt: DateTime(2026, 9, 1),
        updatedAt: DateTime(2026, 9, 1),
      );

      await repo.addMeeting(
        committeeId: 'c1',
        meeting: meeting,
        actorName: 'Lead',
        actorRole: 'head',
      );

      expect(repo.lastAddedMeeting, isNotNull);
      expect(repo.lastAddedMeeting!.title, 'Weekly Sync');
      expect(repo.lastAddedMeeting!.description, 'Sync meeting description');
    });

    test('EventsRepository mock implementation fulfills contract', () async {
      final repo = MockEventsRepository();
      final event = EventModel(
        id: 'ev1',
        title: 'Orientation Day',
        description: 'Welcome new members',
        date: DateTime(2026, 9, 15),
        createdBy: 'u1',
        createdAt: DateTime(2026, 9, 1),
        updatedAt: DateTime(2026, 9, 1),
      );

      await repo.addEvent(
        committeeId: 'c1',
        event: event,
        actorName: 'Coordinator',
        actorRole: 'member',
      );

      expect(repo.lastAddedEvent, isNotNull);
      expect(repo.lastAddedEvent!.title, 'Orientation Day');
    });

    test('NotificationsRepository mock implementation fulfills contract',
        () async {
      final repo = MockNotificationsRepository();
      final notif = NotificationModel(
        id: 'n1',
        actorId: 'a1',
        actorName: 'HR Team',
        actorRole: 'hr',
        type: NotificationType.mohsenAdded,
        title: 'New Mohsen',
        message: 'You received +5',
        committeeId: 'c1',
        createdAt: DateTime(2026, 9, 7),
      );

      expectLater(
        repo.watchNotifications(committeeId: 'c1', uid: 'u1'),
        emits([notif]),
      );

      repo.controller.add([notif]);
    });

    test('StatsRepository mock implementation fulfills contract', () async {
      final repo = MockStatsRepository();
      repo.mockStats = MonthlyStatsModel(
        monthKey: '2026-09',
        sessionsAttended: 4,
        sessionsTotal: 4,
        tasksCompleted: 2,
        tasksTotal: 2,
        scorePercent: 100.0,
        computedAt: DateTime(2026, 9, 7),
      );

      final stats = await repo.getMemberMonthlyStats(
        committeeId: 'c1',
        uid: 'u1',
        monthKey: '2026-09',
      );

      expect(stats, isNotNull);
      expect(stats!.sessionsAttended, 4);
      expect(stats.scorePercent, 100.0);
    });
  });

  group('UserModel Equality & HashCode Tests', () {
    final now = DateTime(2026, 9, 7);

    test('Two identical UserModels are equal and have matching hashCodes', () {
      final userA = UserModel(
        uid: 'u123',
        name: 'Fatma',
        email: 'fatma@test.com',
        committees: ['c1', 'c2'],
        defaultCommitteeId: 'c1',
        createdAt: now,
        updatedAt: now,
      );

      final userB = UserModel(
        uid: 'u123',
        name: 'Fatma',
        email: 'fatma@test.com',
        committees: ['c1', 'c2'],
        defaultCommitteeId: 'c1',
        createdAt: now,
        updatedAt: now,
      );

      expect(userA, equals(userB));
      expect(userA.hashCode, equals(userB.hashCode));
    });

    test('UserModels with different properties are not equal', () {
      final userA = UserModel(
        uid: 'u123',
        name: 'Fatma',
        email: 'fatma@test.com',
        committees: ['c1'],
        defaultCommitteeId: 'c1',
        createdAt: now,
        updatedAt: now,
      );

      final userDifferentName = userA.copyWith(name: 'Fatma Khaled');
      final userDifferentEmail = userA.copyWith(email: 'other@test.com');
      final userDifferentCommittees = userA.copyWith(committees: ['c1', 'c2']);

      expect(userA == userDifferentName, isFalse);
      expect(userA == userDifferentEmail, isFalse);
      expect(userA == userDifferentCommittees, isFalse);
    });
  });
}
