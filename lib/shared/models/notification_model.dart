import 'date_time_helper.dart';

enum NotificationType {
  mohsenAdded('mohsenAdded'),
  warningAdded('warningAdded'),
  meetingAdded('meetingAdded'),
  eventAdded('eventAdded');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromString(String? value) {
    switch (value) {
      case 'mohsenAdded':
      case 'mohsen_added':
        return NotificationType.mohsenAdded;
      case 'warningAdded':
      case 'warning_added':
        return NotificationType.warningAdded;
      case 'meetingAdded':
      case 'meeting_added':
        return NotificationType.meetingAdded;
      case 'eventAdded':
      case 'event_added':
        return NotificationType.eventAdded;
      default:
        return NotificationType.mohsenAdded;
    }
  }
}

class NotificationModel {
  final String id;
  final String actorId;
  final String actorName;
  final String actorRole;
  final NotificationType type;
  final String title;
  final String message;
  final String committeeId;
  final String? targetUserId;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.actorId,
    required this.actorName,
    required this.actorRole,
    required this.type,
    required this.title,
    required this.message,
    required this.committeeId,
    this.targetUserId,
    required this.createdAt,
  });

  /// Client-side check to see if notification is unread relative to member's last seen timestamp.
  bool isUnread(DateTime? lastSeenNotificationsAt) {
    if (lastSeenNotificationsAt == null) return true;
    return createdAt.isAfter(lastSeenNotificationsAt);
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return NotificationModel(
      id: id ?? (map['id'] as String? ?? ''),
      actorId: map['actorId'] as String? ?? '',
      actorName: map['actorName'] as String? ?? '',
      actorRole: map['actorRole'] as String? ?? '',
      type: NotificationType.fromString(map['type'] as String?),
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      committeeId: map['committeeId'] as String? ?? '',
      targetUserId: map['targetUserId'] as String?,
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actorId': actorId,
      'actorName': actorName,
      'actorRole': actorRole,
      'type': type.value,
      'title': title,
      'message': message,
      'committeeId': committeeId,
     'targetUserId': targetUserId,
      'createdAt': createdAt,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? actorId,
    String? actorName,
    String? actorRole,
    NotificationType? type,
    String? title,
    String? message,
    String? committeeId,
    String? targetUserId,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      actorRole: actorRole ?? this.actorRole,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      committeeId: committeeId ?? this.committeeId,
      targetUserId: targetUserId ?? this.targetUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          actorId == other.actorId &&
          actorName == other.actorName &&
          actorRole == other.actorRole &&
          type == other.type &&
          title == other.title &&
          message == other.message &&
          committeeId == other.committeeId &&
          targetUserId == other.targetUserId &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      actorId.hashCode ^
      actorName.hashCode ^
      actorRole.hashCode ^
      type.hashCode ^
      title.hashCode ^
      message.hashCode ^
      committeeId.hashCode ^
      targetUserId.hashCode ^
      createdAt.hashCode;

  @override
  String toString() =>
      'NotificationModel(id: $id, actorId: $actorId, actorName: $actorName, actorRole: $actorRole, type: ${type.value}, title: $title, message: $message, committeeId: $committeeId, targetUserId: $targetUserId, createdAt: $createdAt)';
}
