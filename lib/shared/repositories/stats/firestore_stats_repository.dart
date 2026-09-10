import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'stats_repository.dart';

class FirestoreStatsRepository implements StatsRepository {
  final FirebaseFirestore _firestore;

  FirestoreStatsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
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

  @override
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
}
