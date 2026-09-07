import '../../models/models.dart';

abstract class StatsRepository {
  Future<MonthlyStatsModel?> getMemberMonthlyStats({
    required String committeeId,
    required String uid,
    required String monthKey,
  });

  Future<List<SessionRecordModel>> getSessionRecords({
    required String committeeId,
    required String uid,
  });
}
