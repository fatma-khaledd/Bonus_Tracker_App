import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'notifications_repository.dart';

class FirestoreNotificationsRepository implements NotificationsRepository {
  final FirebaseFirestore _firestore;

  FirestoreNotificationsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
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
