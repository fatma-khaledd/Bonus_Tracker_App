import '../../models/models.dart';

abstract class MeetingsRepository {
  Future<void> addMeeting({
    required String committeeId,
    required MeetingModel meeting,
    required String actorName,
    required String actorRole,
    String? notificationTitle,
    String? notificationMessage,
  });
  Future<List<MeetingModel>> getMeetings(String committeeId);
}
