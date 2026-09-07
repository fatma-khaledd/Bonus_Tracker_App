import '../../models/models.dart';

abstract class EventsRepository {
  Future<void> addEvent({
    required String committeeId,
    required EventModel event,
    required String actorName,
    required String actorRole,
  });
}
