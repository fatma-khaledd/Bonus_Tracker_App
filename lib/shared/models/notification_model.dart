import 'date_time_helper.dart';

class NotificationModel {
  final String id;
  final String actorId;
  final String actorRole;
  final String type;
  final String title;
  final String message;
  final String committeeId;
  final String targetUserId;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.actorId,
    required this.actorRole,
    required this.type,
    required this.title,
    required this.message,
    required this.committeeId,
    required this.targetUserId,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return NotificationModel(
      id: id ?? (map['id'] as String? ?? ''),
      actorId: map['actorId'] as String? ?? '',
      actorRole: map['actorRole'] as String? ?? '',
      type: map['type'] as String? ?? '',
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      committeeId: map['committeeId'] as String? ?? '',
      targetUserId: map['targetUserId'] as String? ?? '',
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actorId': actorId,
      'actorRole': actorRole,
      'type': type,
      'title': title,
      'message': message,
      'committeeId': committeeId,
      'targetUserId': targetUserId,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? actorId,
    String? actorRole,
    String? type,
    String? title,
    String? message,
    String? committeeId,
    String? targetUserId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      actorId: actorId ?? this.actorId,
      actorRole: actorRole ?? this.actorRole,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      committeeId: committeeId ?? this.committeeId,
      targetUserId: targetUserId ?? this.targetUserId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          actorId == other.actorId &&
          actorRole == other.actorRole &&
          type == other.type &&
          title == other.title &&
          message == other.message &&
          committeeId == other.committeeId &&
          targetUserId == other.targetUserId &&
          createdAt == other.createdAt &&
          isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      actorId.hashCode ^
      actorRole.hashCode ^
      type.hashCode ^
      title.hashCode ^
      message.hashCode ^
      committeeId.hashCode ^
      targetUserId.hashCode ^
      createdAt.hashCode ^
      isRead.hashCode;

  @override
  String toString() =>
      'NotificationModel(id: $id, actorId: $actorId, actorRole: $actorRole, type: $type, title: $title, message: $message, committeeId: $committeeId, targetUserId: $targetUserId, createdAt: $createdAt, isRead: $isRead)';
}
