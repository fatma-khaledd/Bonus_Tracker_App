import '../../models/models.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationModel>> watchNotifications({
    required String committeeId,
    required String uid,
  });
 
}
