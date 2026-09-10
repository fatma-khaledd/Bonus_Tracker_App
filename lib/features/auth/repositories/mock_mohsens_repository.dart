import '../../../shared/models/models.dart';
import '../../../shared/repositories/mohsens/mohsens_repository.dart';

class MockMohsensRepository implements MohsensRepository {
  final List<MohsenEntryModel> entries = [
    MohsenEntryModel(
      id: '1',
      memberId: 'member1',
      committeeId: 'committee1',
      type: MohsenType.mohsen,
      value: 1,
      reason: 'Was active in session 2',
      addedBy: 'user1',
      createdAt: DateTime(2026, 8, 19, 10, 30),
      updatedAt: DateTime(2026, 8, 19, 10, 30),
    ),
    MohsenEntryModel(
      id: '2',
      memberId: 'member1',
      committeeId: 'committee1',
      type: MohsenType.mohsen,
      value: 1,
      reason: 'Helped a team member',
      addedBy: 'user1',
      createdAt: DateTime(2026, 8, 18, 14, 15),
      updatedAt: DateTime(2026, 8, 18, 14, 15),
    ),
    MohsenEntryModel(
      id: '3',
      memberId: 'member1',
      committeeId: 'committee1',
      type: MohsenType.mohsen,
      value: 1,
      reason: 'Completed task early',
      addedBy: 'user1',
      createdAt: DateTime(2026, 8, 18, 9, 20),
      updatedAt: DateTime(2026, 8, 18, 9, 20),
    ),
    MohsenEntryModel(
      id: '4',
      memberId: 'member1',
      committeeId: 'committee1',
      type: MohsenType.mohsen,
      value: 1,
      reason: 'Good attitude',
      addedBy: 'user1',
      createdAt: DateTime(2026, 8, 17, 13, 45),
      updatedAt: DateTime(2026, 8, 17, 13, 45),
    ),
    MohsenEntryModel(
      id: '5',
      memberId: 'member1',
      committeeId: 'committee1',
      type: MohsenType.mohsen,
      value: 2,
      reason: 'Participated in discussion',
      addedBy: 'user1',
      createdAt: DateTime(2026, 8, 17, 11, 10),
      updatedAt: DateTime(2026, 8, 17, 11, 10),
    ),
  ];

  @override
  Future<List<MohsenEntryModel>> getMohsensHistory({
    required String committeeId,
    required String uid,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return entries;
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
    entries.add(entry);
  }
}
