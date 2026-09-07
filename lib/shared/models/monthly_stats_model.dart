import 'date_time_helper.dart';

class MonthlyStatsModel {
  final String monthKey;
  final String? memberId;
  final String? committeeId;
  final int sessionsAttended;
  final int sessionsTotal;
  final int tasksCompleted;
  final int tasksTotal;
  final num scorePercent;
  final DateTime computedAt;

  const MonthlyStatsModel({
    required this.monthKey,
    this.memberId,
    this.committeeId,
    this.sessionsAttended = 0,
    this.sessionsTotal = 0,
    this.tasksCompleted = 0,
    this.tasksTotal = 0,
    this.scorePercent = 0.0,
    required this.computedAt,
  });

  factory MonthlyStatsModel.fromMap(
    Map<String, dynamic> map, {
    String? monthKey,
    String? memberId,
    String? committeeId,
  }) {
    return MonthlyStatsModel(
      monthKey: monthKey ?? (map['monthKey'] as String? ?? ''),
      memberId: memberId ?? map['memberId'] as String?,
      committeeId: committeeId ?? map['committeeId'] as String?,
      sessionsAttended: (map['sessionsAttended'] as num?)?.toInt() ?? 0,
      sessionsTotal: (map['sessionsTotal'] as num?)?.toInt() ?? 0,
      tasksCompleted: (map['tasksCompleted'] as num?)?.toInt() ?? 0,
      tasksTotal: (map['tasksTotal'] as num?)?.toInt() ?? 0,
      scorePercent: (map['scorePercent'] as num?) ?? 0.0,
      computedAt: DateTimeHelper.parseOrNow(map['computedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (memberId != null) 'memberId': memberId,
      if (committeeId != null) 'committeeId': committeeId,
      'sessionsAttended': sessionsAttended,
      'sessionsTotal': sessionsTotal,
      'tasksCompleted': tasksCompleted,
      'tasksTotal': tasksTotal,
      'scorePercent': scorePercent,
      'computedAt': computedAt,
    };
  }

  MonthlyStatsModel copyWith({
    String? monthKey,
    String? memberId,
    String? committeeId,
    int? sessionsAttended,
    int? sessionsTotal,
    int? tasksCompleted,
    int? tasksTotal,
    num? scorePercent,
    DateTime? computedAt,
  }) {
    return MonthlyStatsModel(
      monthKey: monthKey ?? this.monthKey,
      memberId: memberId ?? this.memberId,
      committeeId: committeeId ?? this.committeeId,
      sessionsAttended: sessionsAttended ?? this.sessionsAttended,
      sessionsTotal: sessionsTotal ?? this.sessionsTotal,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      tasksTotal: tasksTotal ?? this.tasksTotal,
      scorePercent: scorePercent ?? this.scorePercent,
      computedAt: computedAt ?? this.computedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyStatsModel &&
          runtimeType == other.runtimeType &&
          monthKey == other.monthKey &&
          memberId == other.memberId &&
          committeeId == other.committeeId &&
          sessionsAttended == other.sessionsAttended &&
          sessionsTotal == other.sessionsTotal &&
          tasksCompleted == other.tasksCompleted &&
          tasksTotal == other.tasksTotal &&
          scorePercent == other.scorePercent &&
          computedAt == other.computedAt;

  @override
  int get hashCode =>
      monthKey.hashCode ^
      memberId.hashCode ^
      committeeId.hashCode ^
      sessionsAttended.hashCode ^
      sessionsTotal.hashCode ^
      tasksCompleted.hashCode ^
      tasksTotal.hashCode ^
      scorePercent.hashCode ^
      computedAt.hashCode;

  @override
  String toString() =>
      'MonthlyStatsModel(monthKey: $monthKey, memberId: $memberId, committeeId: $committeeId, sessionsAttended: $sessionsAttended, sessionsTotal: $sessionsTotal, tasksCompleted: $tasksCompleted, tasksTotal: $tasksTotal, scorePercent: $scorePercent, computedAt: $computedAt)';
}
