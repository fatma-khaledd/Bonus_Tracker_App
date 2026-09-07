import 'date_time_helper.dart';

enum SessionType {
  meeting('meeting'),
  event('event');

  final String value;
  const SessionType(this.value);

  static SessionType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'event':
        return SessionType.event;
      case 'meeting':
      default:
        return SessionType.meeting;
    }
  }
}

enum AttendanceStatus {
  onTime('onTime'),
  lateExcused('lateExcused'),
  lateUnexcused('lateUnexcused'),
  absentExcused('absentExcused');

  final String value;
  const AttendanceStatus(this.value);

  static AttendanceStatus fromString(String? value) {
    switch (value) {
      case 'lateExcused':
        return AttendanceStatus.lateExcused;
      case 'lateUnexcused':
        return AttendanceStatus.lateUnexcused;
      case 'absentExcused':
        return AttendanceStatus.absentExcused;
      case 'onTime':
      default:
        return AttendanceStatus.onTime;
    }
  }
}

enum TaskStatus {
  completedEarly('completedEarly'),
  lateExcused('lateExcused'),
  notDelivered('notDelivered'),
  none('none');

  final String value;
  const TaskStatus(this.value);

  static TaskStatus fromString(String? value) {
    switch (value) {
      case 'completedEarly':
        return TaskStatus.completedEarly;
      case 'lateExcused':
        return TaskStatus.lateExcused;
      case 'notDelivered':
        return TaskStatus.notDelivered;
      case 'none':
      default:
        return TaskStatus.none;
    }
  }
}

class SessionRecordModel {
  final String sessionId;
  final String? memberId;
  final String? committeeId;
  final String sessionRef;
  final SessionType sessionType;
  final AttendanceStatus attendanceStatus;
  final TaskStatus taskStatus;
  final String recordedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionRecordModel({
    required this.sessionId,
    this.memberId,
    this.committeeId,
    required this.sessionRef,
    required this.sessionType,
    required this.attendanceStatus,
    required this.taskStatus,
    required this.recordedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionRecordModel.fromMap(
    Map<String, dynamic> map, {
    String? sessionId,
    String? memberId,
    String? committeeId,
  }) {
    return SessionRecordModel(
      sessionId: sessionId ?? (map['sessionId'] as String? ?? ''),
      memberId: memberId ?? map['memberId'] as String?,
      committeeId: committeeId ?? map['committeeId'] as String?,
      sessionRef: map['sessionRef'] as String? ?? '',
      sessionType: SessionType.fromString(map['sessionType'] as String?),
      attendanceStatus:
          AttendanceStatus.fromString(map['attendanceStatus'] as String?),
      taskStatus: TaskStatus.fromString(map['taskStatus'] as String?),
      recordedBy: map['recordedBy'] as String? ?? '',
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
      updatedAt: DateTimeHelper.parseOrNow(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (memberId != null) 'memberId': memberId,
      if (committeeId != null) 'committeeId': committeeId,
      'sessionRef': sessionRef,
      'sessionType': sessionType.value,
      'attendanceStatus': attendanceStatus.value,
      'taskStatus': taskStatus.value,
      'recordedBy': recordedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  SessionRecordModel copyWith({
    String? sessionId,
    String? memberId,
    String? committeeId,
    String? sessionRef,
    SessionType? sessionType,
    AttendanceStatus? attendanceStatus,
    TaskStatus? taskStatus,
    String? recordedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionRecordModel(
      sessionId: sessionId ?? this.sessionId,
      memberId: memberId ?? this.memberId,
      committeeId: committeeId ?? this.committeeId,
      sessionRef: sessionRef ?? this.sessionRef,
      sessionType: sessionType ?? this.sessionType,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      taskStatus: taskStatus ?? this.taskStatus,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionRecordModel &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          memberId == other.memberId &&
          committeeId == other.committeeId &&
          sessionRef == other.sessionRef &&
          sessionType == other.sessionType &&
          attendanceStatus == other.attendanceStatus &&
          taskStatus == other.taskStatus &&
          recordedBy == other.recordedBy &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      sessionId.hashCode ^
      memberId.hashCode ^
      committeeId.hashCode ^
      sessionRef.hashCode ^
      sessionType.hashCode ^
      attendanceStatus.hashCode ^
      taskStatus.hashCode ^
      recordedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'SessionRecordModel(sessionId: $sessionId, memberId: $memberId, committeeId: $committeeId, sessionRef: $sessionRef, sessionType: ${sessionType.value}, attendanceStatus: ${attendanceStatus.value}, taskStatus: ${taskStatus.value}, recordedBy: $recordedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}
