import '../../models/models.dart';

abstract class MohsensRepository {
  Future<List<MohsenEntryModel>> getMohsensHistory({
    required String committeeId,
    required String uid,
  });

  Future<void> addMohsenEntry({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel entry,
    required String actorName,
    required String actorRole,
  });
}
