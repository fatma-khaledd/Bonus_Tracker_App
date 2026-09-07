import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/models.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;

  FirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<MemberModel>> getMembersList(String committeeId) async {
    final snap = await _firestore
        .collection(FirestorePaths.members(committeeId))
        .get();

    return snap.docs
        .map((doc) => MemberModel.fromMap(
              doc.data(),
              userId: doc.id,
              committeeId: committeeId,
            ))
        .toList();
  }

  Future<void> markNotificationsSeen({
    required String committeeId,
    required String uid,
  }) async {
    await _firestore.doc(FirestorePaths.member(committeeId, uid)).update({
      'lastSeenNotificationsAt': FieldValue.serverTimestamp(),
    });
  }

  Future<MonthlyStatsModel?> getMemberMonthlyStats({
    required String committeeId,
    required String uid,
    required String monthKey,
  }) async {
    final doc = await _firestore
        .doc(FirestorePaths.monthlyStat(committeeId, uid, monthKey))
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return MonthlyStatsModel.fromMap(doc.data()!, monthKey: doc.id);
  }

  Future<List<SessionRecordModel>> getSessionRecords({
    required String committeeId,
    required String uid,
  }) async {
    final snap = await _firestore
        .collection(FirestorePaths.sessionRecords(committeeId, uid))
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((doc) => SessionRecordModel.fromMap(doc.data(), sessionId: doc.id))
        .toList();
  }

  Future<List<MohsenEntryModel>> getMohsensHistory({
    required String committeeId,
    required String uid,
  }) async {
    final snap = await _firestore
        .collection(FirestorePaths.mohsens(committeeId, uid))
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((doc) => MohsenEntryModel.fromMap(
              doc.data(),
              id: doc.id,
              memberId: uid,
              committeeId: committeeId,
            ))
        .toList();
  }

  Future<void> addMohsenEntry({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel entry,
    required String actorName,
  }) async {
    final memberRef =
        _firestore.doc(FirestorePaths.member(committeeId, memberId));
    final entryRef = _firestore
        .collection(FirestorePaths.mohsens(committeeId, memberId))
        .doc();
    final notifRef =
        _firestore.collection(FirestorePaths.notifications()).doc();

    final isMohsen = entry.type == MohsenType.mohsen;
    final statField = isMohsen ? 'mohsensCount' : 'warningsCount';
    final notifType =
        isMohsen ? NotificationType.mohsenAdded : NotificationType.warningAdded;
    final notifTitle = isMohsen ? 'محسن جديد' : 'تحذير جديد';
    final notifMessage =
        '$actorName أضاف ${isMohsen ? "محسن" : "تحذير"}: ${entry.reason}';

    await _firestore.runTransaction((transaction) async {
      final memberSnap = await transaction.get(memberRef);
      final currentStats =
          (memberSnap.data()?['stats'] as Map<String, dynamic>?) ?? {};
      final currentValue = (currentStats[statField] ?? 0) as num;

      transaction.set(entryRef, entry.toMap());

      transaction.update(memberRef, {
        'stats.$statField': currentValue + entry.value,
        'stats.lastUpdatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(notifRef, {
        'actorId': entry.addedBy,
        'actorName': actorName,
        'actorRole': 'hr',
        'type': notifType.value,
        'title': notifTitle,
        'message': notifMessage,
        'committeeId': committeeId,
        'targetUserId': memberId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> addMeeting({
    required String committeeId,
    required MeetingModel meeting,
    required String actorName,
  }) async {
    final batch = _firestore.batch();
    final meetingRef = meeting.id.isNotEmpty
        ? _firestore.doc(FirestorePaths.meeting(committeeId, meeting.id))
        : _firestore.collection(FirestorePaths.meetings(committeeId)).doc();

    final notifRef =
        _firestore.collection(FirestorePaths.notifications()).doc();

    batch.set(meetingRef, meeting.toMap());
    batch.set(notifRef, {
      'actorId': meeting.createdBy,
      'actorName': actorName,
      'actorRole': 'hr',
      'type': NotificationType.meetingAdded.value,
      'title': 'اجتماع جديد: ${meeting.title}',
      'message': meeting.description.isNotEmpty
          ? meeting.description
          : 'تمت إضافة اجتماع جديد للجنة',
      'committeeId': committeeId,
      'targetUserId': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> addEvent({
    required String committeeId,
    required EventModel event,
    required String actorName,
  }) async {
    final batch = _firestore.batch();
    final eventRef = event.id.isNotEmpty
        ? _firestore.doc(FirestorePaths.event(committeeId, event.id))
        : _firestore.collection(FirestorePaths.events(committeeId)).doc();

    final notifRef =
        _firestore.collection(FirestorePaths.notifications()).doc();

    batch.set(eventRef, event.toMap());
    batch.set(notifRef, {
      'actorId': event.createdBy,
      'actorName': actorName,
      'actorRole': 'hr',
      'type': NotificationType.eventAdded.value,
      'title': 'فعالية جديدة: ${event.title}',
      'message': event.description.isNotEmpty
          ? event.description
          : 'تمت إضافة فعالية جديدة للجنة',
      'committeeId': committeeId,
      'targetUserId': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Stream<List<NotificationModel>> watchNotifications({
    required String committeeId,
    required String uid,
  }) {
    late StreamController<List<NotificationModel>> controller;
    StreamSubscription? personalSub;
    StreamSubscription? broadcastSub;
    List<NotificationModel>? lastPersonal;
    List<NotificationModel>? lastBroadcast;

    void emitIfReady() {
      if (lastPersonal != null && lastBroadcast != null) {
        final combined = [...lastPersonal!, ...lastBroadcast!];
        combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (!controller.isClosed) {
          controller.add(combined);
        }
      }
    }

    controller = StreamController<List<NotificationModel>>.broadcast(
      onListen: () {
        personalSub = _firestore
            .collection(FirestorePaths.notifications())
            .where('committeeId', isEqualTo: committeeId)
            .where('targetUserId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen((snap) {
          lastPersonal = snap.docs
              .map((d) => NotificationModel.fromMap(d.data(), id: d.id))
              .toList();
          emitIfReady();
        }, onError: (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
        });

        broadcastSub = _firestore
            .collection(FirestorePaths.notifications())
            .where('committeeId', isEqualTo: committeeId)
            .where('targetUserId', isNull: true)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen((snap) {
          lastBroadcast = snap.docs
              .map((d) => NotificationModel.fromMap(d.data(), id: d.id))
              .toList();
          emitIfReady();
        }, onError: (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
        });
      },
      onCancel: () async {
        await personalSub?.cancel();
        await broadcastSub?.cancel();
      },
    );

    return controller.stream;
  }
}
