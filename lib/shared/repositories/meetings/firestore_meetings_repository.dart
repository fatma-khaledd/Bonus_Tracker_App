import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'meetings_repository.dart';

class FirestoreMeetingsRepository implements MeetingsRepository {
  final FirebaseFirestore _firestore;

  FirestoreMeetingsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addMeeting({
    required String committeeId,
    required MeetingModel meeting,
    required String actorName,
    required String actorRole,
    String? notificationTitle,
    String? notificationMessage,
  }) async {
    final batch = _firestore.batch();
    final meetingRef = meeting.id.isNotEmpty
        ? _firestore.doc(FirestorePaths.meeting(committeeId, meeting.id))
        : _firestore.collection(FirestorePaths.meetings(committeeId)).doc();

    final notifRef = _firestore
        .collection(FirestorePaths.notifications())
        .doc();

    final notification = NotificationModel(
      id: notifRef.id,
      actorId: meeting.createdBy,
      actorName: actorName,
      actorRole: actorRole,
      type: NotificationType.meetingAdded,
      title: notificationTitle ?? 'New Meeting: ${meeting.title}',
      message:
          notificationMessage ??
          (meeting.description.isNotEmpty
              ? meeting.description
              : 'A new meeting has been scheduled'),
      committeeId: committeeId,
      createdAt: DateTime.now(),
    );

    batch.set(meetingRef, meeting.toMap());

    final notifMap = notification.toMap();
    notifMap['createdAt'] = FieldValue.serverTimestamp();
    batch.set(notifRef, notifMap);

    await batch.commit();
  }
}
