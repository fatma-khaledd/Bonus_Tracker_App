import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../models/models.dart';
import 'members_repository.dart';

class FirestoreMembersRepository implements MembersRepository {
  final FirebaseFirestore _firestore;

  FirestoreMembersRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<MemberModel>> getMembersList(String committeeId) async {
    final snap = await _firestore
        .collection(FirestorePaths.members(committeeId))
        .get();

    return snap.docs
        .map(
          (doc) => MemberModel.fromMap(
            doc.data(),
            userId: doc.id,
            committeeId: committeeId,
          ),
        )
        .toList();
  }

  @override
  Future<void> markNotificationsSeen({
    required String committeeId,
    required String uid,
  }) async {
    await _firestore.doc(FirestorePaths.member(committeeId, uid)).update({
      'lastSeenNotificationsAt': FieldValue.serverTimestamp(),
    });
  }
}
