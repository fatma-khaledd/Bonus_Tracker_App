import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'mohsens_repository.dart';

class FirestoreMohsensRepository implements MohsensRepository {
  final FirebaseFirestore _firestore;

  FirestoreMohsensRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
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
    final memberRef =
        _firestore.doc(FirestorePaths.member(committeeId, memberId));
    final entryRef = _firestore
        .collection(FirestorePaths.mohsens(committeeId, memberId))
        .doc();
    final notifRef =
        _firestore.collection(FirestorePaths.notifications()).doc();

    final isMohsen = entry.type == MohsenType.mohsen;
    final statField = isMohsen ? 'mohsensCount' : 'warningsCount';

    final notification = NotificationModel(
      id: notifRef.id,
      actorId: entry.addedBy,
      actorName: actorName,
      actorRole: actorRole,
      type: isMohsen
          ? NotificationType.mohsenAdded
          : NotificationType.warningAdded,
      title: notificationTitle ?? (isMohsen ? 'New Mohsen' : 'New Warning'),
      message: notificationMessage ??
          '$actorName added ${isMohsen ? "mohsen" : "warning"}: ${entry.reason}',
      committeeId: committeeId,
      targetUserId: memberId,
      createdAt: DateTime.now(),
    );

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

      final notifMap = notification.toMap();
      notifMap['createdAt'] = FieldValue.serverTimestamp();
      transaction.set(notifRef, notifMap);
    });
  }
}
