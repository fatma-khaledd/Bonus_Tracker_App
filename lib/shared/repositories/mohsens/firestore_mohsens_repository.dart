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
        .map(
          (doc) => MohsenEntryModel.fromMap(
            doc.data(),
            id: doc.id,
            memberId: uid,
            committeeId: committeeId,
          ),
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
    final memberRef = _firestore.doc(
      FirestorePaths.member(committeeId, memberId),
    );
    final entryRef = _firestore
        .collection(FirestorePaths.mohsens(committeeId, memberId))
        .doc();
    final notifRef = _firestore
        .collection(FirestorePaths.notifications())
        .doc();

    final isMohsen = entry.type == MohsenType.mohsen;
    final statField = isMohsen ? 'mohsensCount' : 'warningsCount';

    final entryLabel = entry.title.trim().isNotEmpty
        ? entry.title.trim()
        : entry.reason.trim();

    final isRemoval = entry.value < 0;
    final defaultTitle = isRemoval
        ? (isMohsen ? 'Mohsen Removed' : 'Warning Removed')
        : (isMohsen ? 'New Mohsen' : 'New Warning');
    final actionVerb = isRemoval ? 'removed' : 'added';

    final notification = NotificationModel(
      id: notifRef.id,
      actorId: entry.addedBy,
      actorName: actorName,
      actorRole: actorRole,
      type: isMohsen
          ? NotificationType.mohsenAdded
          : NotificationType.warningAdded,
      title: notificationTitle ?? defaultTitle,
      message:
          notificationMessage ??
          (entryLabel.isNotEmpty 
            ? '$actorName $actionVerb ${isMohsen ? "mohsen" : "warning"}: $entryLabel'
            : '$actorName $actionVerb ${isMohsen ? "mohsen" : "warning"}'),
      committeeId: committeeId,
      targetUserId: memberId,
      createdAt: DateTime.now(),
    );

    await _firestore.runTransaction((transaction) async {
      final memberSnap = await transaction.get(memberRef);
      final currentStats =
          (memberSnap.data()?['stats'] as Map<String, dynamic>?) ?? {};
      final currentValue = (currentStats[statField] ?? 0) as num;

      final updatedTotal = currentValue + entry.value;
      final safeTotal = updatedTotal < 0 ? 0 : updatedTotal;

      transaction.set(entryRef, entry.toMap());

      transaction.update(memberRef, {
        'stats.$statField': safeTotal,
        'stats.lastUpdatedAt': FieldValue.serverTimestamp(),
      });

      final notifMap = notification.toMap();
      notifMap['createdAt'] = FieldValue.serverTimestamp();
      transaction.set(notifRef, notifMap);
    });
  }

  @override
  Stream<List<MohsenEntryModel>> streamMohsensHistory({
    required String committeeId,
    required String uid,
  }) {
    return _firestore
        .collection(FirestorePaths.mohsens(committeeId, uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MohsenEntryModel.fromMap(
                  doc.data(),
                  id: doc.id,
                  memberId: uid,
                  committeeId: committeeId,
                ))
            .toList());
  }

  @override
  Future<void> updateMohsenEntry({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel entry,
  }) async {
    final memberRef = _firestore.doc(
      FirestorePaths.member(committeeId, memberId),
    );
    final entryRef = _firestore
        .collection(FirestorePaths.mohsens(committeeId, memberId))
        .doc(entry.id);

    await _firestore.runTransaction((transaction) async {
      final entrySnapshot = await transaction.get(entryRef);
      final data = entrySnapshot.data();
      if (!entrySnapshot.exists || data == null) {
        throw StateError('The history entry no longer exists.');
      }

      final oldEntry = MohsenEntryModel.fromMap(
        data,
        id: entrySnapshot.id,
        memberId: memberId,
        committeeId: committeeId,
      );
      final oldStatField = _statField(oldEntry.type);
      final newStatField = _statField(entry.type);

      transaction.update(entryRef, {
        'type': entry.type.value,
        'value': entry.value,
        'reason': entry.reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (oldStatField == newStatField) {
        transaction.update(memberRef, {
          'stats.$newStatField': FieldValue.increment(
            entry.value - oldEntry.value,
          ),
          'stats.lastUpdatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.update(memberRef, {
          'stats.$oldStatField': FieldValue.increment(-oldEntry.value),
          'stats.$newStatField': FieldValue.increment(entry.value),
          'stats.lastUpdatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Future<void> deleteMohsenEntry({
    required String committeeId,
    required String memberId,
    required String entryId,
  }) async {
    final memberRef = _firestore.doc(
      FirestorePaths.member(committeeId, memberId),
    );
    final entryRef = _firestore
        .collection(FirestorePaths.mohsens(committeeId, memberId))
        .doc(entryId);

    await _firestore.runTransaction((transaction) async {
      final entrySnapshot = await transaction.get(entryRef);
      final data = entrySnapshot.data();
      if (!entrySnapshot.exists || data == null) {
        throw StateError('The history entry no longer exists.');
      }

      final entry = MohsenEntryModel.fromMap(
        data,
        id: entrySnapshot.id,
        memberId: memberId,
        committeeId: committeeId,
      );

      transaction.delete(entryRef);
      transaction.update(memberRef, {
        'stats.${_statField(entry.type)}': FieldValue.increment(-entry.value),
        'stats.lastUpdatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  String _statField(MohsenType type) {
    return type == MohsenType.mohsen ? 'mohsensCount' : 'warningsCount';
  }
}

