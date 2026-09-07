import '../../models/models.dart';

abstract class MembersRepository {
  Future<List<MemberModel>> getMembersList(String committeeId);

  Future<void> markNotificationsSeen({
    required String committeeId,
    required String uid,
  });
}
