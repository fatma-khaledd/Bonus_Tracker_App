import 'package:flutter_test/flutter_test.dart';
import 'package:bonus_tracker_app/shared/models/models.dart';

void main() {
  group('Seed Data Models Verification', () {
    final now = DateTime(2026, 9, 7, 12, 0, 0);

    test('1. UserModel - test_uid_1 and test_uid_2', () {
      final user1Map = {
        'name': 'Asmaa Test',
        'email': 'asmaa@test.com',
        'committees': ['committee_test'],
        'defaultCommitteeId': 'committee_test',
        'createdAt': now,
        'updatedAt': now,
      };

      final user1 = UserModel.fromMap(user1Map, uid: 'test_uid_1');
      expect(user1.uid, 'test_uid_1');
      expect(user1.name, 'Asmaa Test');
      expect(user1.email, 'asmaa@test.com');
      expect(user1.committees, ['committee_test']);
      expect(user1.defaultCommitteeId, 'committee_test');
      expect(user1.createdAt, now);
      expect(user1.updatedAt, now);

      final user1ToMap = user1.toMap();
      expect(user1ToMap['name'], 'Asmaa Test');
      expect(user1ToMap['email'], 'asmaa@test.com');
      expect(user1ToMap['committees'], ['committee_test']);
      expect(user1ToMap['defaultCommitteeId'], 'committee_test');
      expect(user1ToMap['createdAt'], now);
      expect(user1ToMap['updatedAt'], now);

      final user2Map = {
        'name': 'Karim Test',
        'email': 'karim@test.com',
        'committees': ['committee_test'],
        'defaultCommitteeId': 'committee_test',
        'createdAt': now,
        'updatedAt': now,
      };

      final user2 = UserModel.fromMap(user2Map, uid: 'test_uid_2');
      expect(user2.uid, 'test_uid_2');
      expect(user2.name, 'Karim Test');
      expect(user2.email, 'karim@test.com');
    });

    test('2. CommitteeModel - committee_test', () {
      final committeeMap = {'name': 'لجنة تجريبية', 'createdAt': now};

      final committee = CommitteeModel.fromMap(
        committeeMap,
        id: 'committee_test',
      );
      expect(committee.id, 'committee_test');
      expect(committee.name, 'لجنة تجريبية');
      expect(committee.createdAt, now);

      final committeeToMap = committee.toMap();
      expect(committeeToMap['name'], 'لجنة تجريبية');
      expect(committeeToMap['createdAt'], now);
    });

    test(
      '3. MemberModel & Nested MemberStats, MemberTraits - test_uid_1 and test_uid_2',
      () {
        final member1Map = {
          'userId': 'test_uid_1',
          'displayName': 'Asmaa Test',
          'role': 'hr',
          'joinedAt': now,
          'isActive': true,
          'stats': {
            'mohsensCount': 3,
            'warningsCount': 0,
            'lastUpdatedAt': now,
          },
          'traits': {
            'activeness': 4,
            'teamwork': 5,
            'flexibility': 3,
            'goodAttitude': 5,
            'badAttitude': 0,
          },
          'lastSeenNotificationsAt': now,
        };

        final member1 = MemberModel.fromMap(member1Map, userId: 'test_uid_1');
        expect(member1.userId, 'test_uid_1');
        expect(member1.displayName, 'Asmaa Test');
        expect(member1.role, MemberRole.hr);
        expect(member1.joinedAt, now);
        expect(member1.isActive, isTrue);
        expect(member1.lastSeenNotificationsAt, now);

        expect(member1.stats.mohsensCount, 3);
        expect(member1.stats.warningsCount, 0);
        expect(member1.stats.lastUpdatedAt, now);

        expect(member1.traits.activeness, 4);
        expect(member1.traits.teamwork, 5);
        expect(member1.traits.flexibility, 3);
        expect(member1.traits.goodAttitude, 5);
        expect(member1.traits.badAttitude, 0);

        final member1ToMap = member1.toMap();
        expect(member1ToMap['userId'], 'test_uid_1');
        expect(member1ToMap['displayName'], 'Asmaa Test');
        expect(member1ToMap['role'], 'hr');
        expect(member1ToMap['lastSeenNotificationsAt'], now);
        expect((member1ToMap['stats'] as Map)['mohsensCount'], 3);
        expect((member1ToMap['traits'] as Map)['goodAttitude'], 5);

        final member2Map = {
          'userId': 'test_uid_2',
          'displayName': 'Karim Test',
          'role': 'member',
          'joinedAt': now,
          'isActive': true,
          'stats': {
            'mohsensCount': 1,
            'warningsCount': 1,
            'lastUpdatedAt': now,
          },
          'traits': {
            'activeness': 3,
            'teamwork': 4,
            'flexibility': 4,
            'goodAttitude': 4,
            'badAttitude': 1,
          },
        };

        final member2 = MemberModel.fromMap(member2Map);
        expect(member2.userId, 'test_uid_2');
        expect(member2.displayName, 'Karim Test');
        expect(member2.role, MemberRole.member);
        expect(member2.stats.mohsensCount, 1);
        expect(member2.stats.warningsCount, 1);
        expect(member2.traits.badAttitude, 1);
      },
    );

    test('4. MeetingModel - meeting_1', () {
      final meetingMap = {
        'title': 'الاجتماع الأسبوعي الأول',
        'description': 'مراجعة تقدم الشغل',
        'date': now,
        'createdBy': 'test_uid_1',
        'createdAt': now,
        'updatedAt': now,
      };

      final meeting = MeetingModel.fromMap(meetingMap, id: 'meeting_1');
      expect(meeting.id, 'meeting_1');
      expect(meeting.title, 'الاجتماع الأسبوعي الأول');
      expect(meeting.description, 'مراجعة تقدم الشغل');
      expect(meeting.date, now);
      expect(meeting.createdBy, 'test_uid_1');
      expect(meeting.createdAt, now);
      expect(meeting.updatedAt, now);

      final meetingToMap = meeting.toMap();
      expect(meetingToMap['title'], 'الاجتماع الأسبوعي الأول');
      expect(meetingToMap['createdBy'], 'test_uid_1');
    });

    test('5. EventModel - event_1', () {
      final eventMap = {
        'title': 'صلاخانة',
        'description': 'فعالية تجريبية',
        'date': now,
        'createdBy': 'test_uid_1',
        'createdAt': now,
        'updatedAt': now,
      };

      final event = EventModel.fromMap(eventMap, id: 'event_1');
      expect(event.id, 'event_1');
      expect(event.title, 'صلاخانة');
      expect(event.description, 'فعالية تجريبية');
      expect(event.date, now);
      expect(event.createdBy, 'test_uid_1');
      expect(event.createdAt, now);
      expect(event.updatedAt, now);

      final eventToMap = event.toMap();
      expect(eventToMap['title'], 'صلاخانة');
      expect(eventToMap['createdBy'], 'test_uid_1');
    });

    test('6. MohsenEntryModel - entry_1 and entry_2', () {
      final entry1Map = {
        'type': 'mohsen',
        'value': 1,
        'reason': 'كان نشيط في السيشن التاني',
        'addedBy': 'test_uid_1',
        'createdAt': now,
        'updatedAt': now,
      };

      final entry1 = MohsenEntryModel.fromMap(entry1Map, id: 'entry_1');
      expect(entry1.id, 'entry_1');
      expect(entry1.type, MohsenType.mohsen);
      expect(entry1.value, 1);
      expect(entry1.reason, 'كان نشيط في السيشن التاني');
      expect(entry1.addedBy, 'test_uid_1');

      final entry1ToMap = entry1.toMap();
      expect(entry1ToMap['type'], 'mohsen');
      expect(entry1ToMap['value'], 1);

      final entry2Map = {
        'type': 'warning',
        'value': 1,
        'reason': 'اتأخر عن الاجتماع',
        'addedBy': 'test_uid_1',
        'createdAt': now,
        'updatedAt': now,
      };

      final entry2 = MohsenEntryModel.fromMap(entry2Map, id: 'entry_2');
      expect(entry2.id, 'entry_2');
      expect(entry2.type, MohsenType.warning);
      expect(entry2.value, 1);
      expect(entry2.reason, 'اتأخر عن الاجتماع');
    });

    test('7. SessionRecordModel - meeting_1', () {
      final sessionMap = {
        'sessionRef': 'meeting_1',
        'sessionType': 'meeting',
        'attendanceStatus': 'onTime',
        'taskStatus': 'completedEarly',
        'recordedBy': 'test_uid_1',
        'createdAt': now,
        'updatedAt': now,
      };

      final record = SessionRecordModel.fromMap(
        sessionMap,
        sessionId: 'meeting_1',
      );
      expect(record.sessionId, 'meeting_1');
      expect(record.sessionRef, 'meeting_1');
      expect(record.sessionType, SessionType.meeting);
      expect(record.attendanceStatus, AttendanceStatus.onTime);
      expect(record.taskStatus, TaskStatus.completedEarly);
      expect(record.recordedBy, 'test_uid_1');
      expect(record.createdAt, now);
      expect(record.updatedAt, now);

      final recordToMap = record.toMap();
      expect(recordToMap['sessionRef'], 'meeting_1');
      expect(recordToMap['sessionType'], 'meeting');
      expect(recordToMap['attendanceStatus'], 'onTime');
      expect(recordToMap['taskStatus'], 'completedEarly');
    });

    test('8. MonthlyStatsModel - 2026-09', () {
      final statsMap = {
        'sessionsAttended': 1,
        'sessionsTotal': 1,
        'tasksCompleted': 1,
        'tasksTotal': 1,
        'scorePercent': 100,
        'computedAt': now,
      };

      final stats = MonthlyStatsModel.fromMap(statsMap, monthKey: '2026-09');
      expect(stats.monthKey, '2026-09');
      expect(stats.sessionsAttended, 1);
      expect(stats.sessionsTotal, 1);
      expect(stats.tasksCompleted, 1);
      expect(stats.tasksTotal, 1);
      expect(stats.scorePercent, 100);
      expect(stats.computedAt, now);

      final statsToMap = stats.toMap();
      expect(statsToMap['sessionsAttended'], 1);
      expect(statsToMap['scorePercent'], 100);
    });

    test('9. NoteModel - note_1', () {
      final noteMap = {
        'ownerId': 'test_uid_1',
        'committeeId': 'committee_test',
        'type': 'hr',
        'title': 'ملاحظة تجريبية',
        'content': 'لازم أراجع أداء كريم الأسبوع الجاي',
        'isDone': false,
        'createdAt': now,
        'updatedAt': now,
      };

      final note = NoteModel.fromMap(noteMap, id: 'note_1');
      expect(note.id, 'note_1');
      expect(note.ownerId, 'test_uid_1');
      expect(note.committeeId, 'committee_test');
      expect(note.type, NoteType.hr);
      expect(note.title, 'ملاحظة تجريبية');
      expect(note.content, 'لازم أراجع أداء كريم الأسبوع الجاي');
      expect(note.isDone, isFalse);
      expect(note.createdAt, now);
      expect(note.updatedAt, now);

      final noteToMap = note.toMap();
      expect(noteToMap['type'], 'hr');
      expect(noteToMap['isDone'], isFalse);
    });

    test(
      '10. NotificationModel - notif_1 (Personal) and notif_2 (Broadcast)',
      () {
        final notif1Map = {
          'actorId': 'test_uid_1',
          'actorName': 'Asmaa Test',
          'actorRole': 'hr',
          'type': 'mohsenAdded',
          'title': 'محسن جديد',
          'message': 'Asmaa Test أضافت محسن لـ Karim Test',
          'committeeId': 'committee_test',
          'targetUserId': 'test_uid_2',
          'createdAt': now,
        };

        final notif1 = NotificationModel.fromMap(notif1Map, id: 'notif_1');
        expect(notif1.id, 'notif_1');
        expect(notif1.actorId, 'test_uid_1');
        expect(notif1.actorName, 'Asmaa Test');
        expect(notif1.actorRole, 'hr');
        expect(notif1.type, NotificationType.mohsenAdded);
        expect(notif1.title, 'محسن جديد');
        expect(notif1.message, 'Asmaa Test أضافت محسن لـ Karim Test');
        expect(notif1.committeeId, 'committee_test');
        expect(notif1.targetUserId, 'test_uid_2');
        expect(notif1.createdAt, now);

        final notif1ToMap = notif1.toMap();
        expect(notif1ToMap['actorName'], 'Asmaa Test');
        expect(notif1ToMap['type'], 'mohsenAdded');
        expect(notif1ToMap['targetUserId'], 'test_uid_2');

        // Test general broadcast notification (targetUserId == null)
        final notif2Map = {
          'actorId': 'test_uid_1',
          'actorName': 'Asmaa Test',
          'actorRole': 'hr',
          'type': 'meetingAdded',
          'title': 'اجتماع جديد',
          'message': 'تمت إضافة اجتماع جديد للجنة',
          'committeeId': 'committee_test',
          'targetUserId': null,
          'createdAt': now,
        };

        final notif2 = NotificationModel.fromMap(notif2Map, id: 'notif_2');
        expect(notif2.targetUserId, isNull);
        expect(notif2.type, NotificationType.meetingAdded);
        expect(notif2.toMap()['targetUserId'], isNull);

        // Test isUnread client-side helper
        final memberLastSeenBefore = now.subtract(const Duration(minutes: 5));
        final memberLastSeenAfter = now.add(const Duration(minutes: 5));
        expect(notif1.isUnread(memberLastSeenBefore), isTrue);
        expect(notif1.isUnread(memberLastSeenAfter), isFalse);
        expect(notif1.isUnread(null), isTrue);
      },
    );
  });
}
