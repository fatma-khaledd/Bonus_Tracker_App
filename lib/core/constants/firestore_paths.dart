/// Defines centralized paths for all Firestore collections and documents.
///
/// Ensures consistent collection/subcollection references across the app
/// and eliminates hardcoded path strings.
class FirestorePaths {
  const FirestorePaths._();

  // 1. Users
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';

  // 2. Committees
  static String committees() => 'committees';
  static String committee(String committeeId) => 'committees/$committeeId';

  // 3. Members (Subcollection under committee)
  static String members(String committeeId) =>
      'committees/$committeeId/members';
  static String member(String committeeId, String uid) =>
      'committees/$committeeId/members/$uid';

  // 4. Meetings (Subcollection under committee)
  static String meetings(String committeeId) =>
      'committees/$committeeId/meetings';
  static String meeting(String committeeId, String meetingId) =>
      'committees/$committeeId/meetings/$meetingId';

  // 5. Events (Subcollection under committee)
  static String events(String committeeId) => 'committees/$committeeId/events';
  static String event(String committeeId, String eventId) =>
      'committees/$committeeId/events/$eventId';

  // 6. Mohsens (Subcollection under member)
  static String mohsens(String committeeId, String uid) =>
      'committees/$committeeId/members/$uid/mohsens';
  static String mohsen(String committeeId, String uid, String entryId) =>
      'committees/$committeeId/members/$uid/mohsens/$entryId';

  // 7. Session Records (Subcollection under member)
  static String sessionRecords(String committeeId, String uid) =>
      'committees/$committeeId/members/$uid/sessionRecords';
  static String sessionRecord(
    String committeeId,
    String uid,
    String sessionId,
  ) =>
      'committees/$committeeId/members/$uid/sessionRecords/$sessionId';

  // 8. Monthly Stats (Subcollection under member)
  static String monthlyStats(String committeeId, String uid) =>
      'committees/$committeeId/members/$uid/monthlyStats';
  static String monthlyStat(
    String committeeId,
    String uid,
    String monthKey,
  ) =>
      'committees/$committeeId/members/$uid/monthlyStats/$monthKey';

  // 9. Notes (Root collection)
  static String notes() => 'notes';
  static String note(String noteId) => 'notes/$noteId';

  // 10. Notifications (Root collection)
  static String notifications() => 'notifications';
  static String notification(String notificationId) =>
      'notifications/$notificationId';
}
