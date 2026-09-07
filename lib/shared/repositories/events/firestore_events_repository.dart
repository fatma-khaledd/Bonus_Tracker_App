import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'events_repository.dart';

class FirestoreEventsRepository implements EventsRepository {
  final FirebaseFirestore _firestore;

  FirestoreEventsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addEvent({
    required String committeeId,
    required EventModel event,
    required String actorName,
    required String actorRole,
    String? notificationTitle,
    String? notificationMessage,
  }) async {
    final batch = _firestore.batch();
    final eventRef = event.id.isNotEmpty
        ? _firestore.doc(FirestorePaths.event(committeeId, event.id))
        : _firestore.collection(FirestorePaths.events(committeeId)).doc();

    final notifRef =
        _firestore.collection(FirestorePaths.notifications()).doc();

    final notification = NotificationModel(
      id: notifRef.id,
      actorId: event.createdBy,
      actorName: actorName,
      actorRole: actorRole,
      type: NotificationType.eventAdded,
      title: notificationTitle ?? 'New Event: ${event.title}',
      message: notificationMessage ??
          (event.description.isNotEmpty
              ? event.description
              : 'A new event has been scheduled'),
      committeeId: committeeId,
      createdAt: DateTime.now(),
    );

    batch.set(eventRef, event.toMap());

    final notifMap = notification.toMap();
    notifMap['createdAt'] = FieldValue.serverTimestamp();
    batch.set(notifRef, notifMap);

    await batch.commit();
  }
}
