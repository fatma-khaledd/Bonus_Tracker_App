import 'package:flutter_test/flutter_test.dart';
import 'package:bonus_tracker_app/core/constants/firestore_paths.dart';

void main() {
  group('FirestorePaths Verification', () {
    const committeeId = 'committee_test';
    const uid1 = 'test_uid_1';

    const uid2 = 'test_uid_2';

    test('1. Users Paths', () {
      expect(FirestorePaths.users(), 'users');
      expect(FirestorePaths.user(uid1), 'users/test_uid_1');
      expect(FirestorePaths.user(uid2), 'users/test_uid_2');
    });

    test('2. Committees Paths', () {
      expect(FirestorePaths.committees(), 'committees');
      expect(
        FirestorePaths.committee(committeeId),
        'committees/committee_test',
      );
    });

    test('3. Members Paths', () {
      expect(
        FirestorePaths.members(committeeId),
        'committees/committee_test/members',
      );
      expect(
        FirestorePaths.member(committeeId, uid1),
        'committees/committee_test/members/test_uid_1',
      );
      expect(
        FirestorePaths.member(committeeId, uid2),
        'committees/committee_test/members/test_uid_2',
      );
    });

    test('4. Meetings Paths', () {
      expect(
        FirestorePaths.meetings(committeeId),
        'committees/committee_test/meetings',
      );
      expect(
        FirestorePaths.meeting(committeeId, 'meeting_1'),
        'committees/committee_test/meetings/meeting_1',
      );
    });

    test('5. Events Paths', () {
      expect(
        FirestorePaths.events(committeeId),
        'committees/committee_test/events',
      );
      expect(
        FirestorePaths.event(committeeId, 'event_1'),
        'committees/committee_test/events/event_1',
      );
    });

    test('6. Mohsens Subcollection Paths', () {
      expect(
        FirestorePaths.mohsens(committeeId, uid2),
        'committees/committee_test/members/test_uid_2/mohsens',
      );
      expect(
        FirestorePaths.mohsen(committeeId, uid2, 'entry_1'),
        'committees/committee_test/members/test_uid_2/mohsens/entry_1',
      );
      expect(
        FirestorePaths.mohsen(committeeId, uid2, 'entry_2'),
        'committees/committee_test/members/test_uid_2/mohsens/entry_2',
      );
    });

    test('7. SessionRecords Subcollection Paths', () {
      expect(
        FirestorePaths.sessionRecords(committeeId, uid2),
        'committees/committee_test/members/test_uid_2/sessionRecords',
      );
      expect(
        FirestorePaths.sessionRecord(committeeId, uid2, 'meeting_1'),
        'committees/committee_test/members/test_uid_2/sessionRecords/meeting_1',
      );
    });

    test('8. MonthlyStats Subcollection Paths', () {
      expect(
        FirestorePaths.monthlyStats(committeeId, uid2),
        'committees/committee_test/members/test_uid_2/monthlyStats',
      );
      expect(
        FirestorePaths.monthlyStat(committeeId, uid2, '2026-09'),
        'committees/committee_test/members/test_uid_2/monthlyStats/2026-09',
      );
    });

    test('9. Notes Paths', () {
      expect(FirestorePaths.notes(), 'notes');
      expect(FirestorePaths.note('note_1'), 'notes/note_1');
    });

    test('10. Notifications Paths', () {
      expect(FirestorePaths.notifications(), 'notifications');
      expect(FirestorePaths.notification('notif_1'), 'notifications/notif_1');
    });
  });
}
