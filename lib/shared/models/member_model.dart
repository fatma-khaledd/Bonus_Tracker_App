import 'date_time_helper.dart';

enum MemberRole {
  member('member'),
  hr('hr'),
  admin('admin');

  final String value;
  const MemberRole(this.value);

  static MemberRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return MemberRole.admin;
      case 'hr':
        return MemberRole.hr;
      case 'member':
      default:
        return MemberRole.member;
    }
  }
}

class MemberStats {
  final int mohsensCount;
  final int warningsCount;
  final DateTime lastUpdatedAt;

  const MemberStats({
    this.mohsensCount = 0,
    this.warningsCount = 0,
    required this.lastUpdatedAt,
  });

  factory MemberStats.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return MemberStats(lastUpdatedAt: DateTime.now());
    }
    return MemberStats(
      mohsensCount: (map['mohsensCount'] as num?)?.toInt() ?? 0,
      warningsCount: (map['warningsCount'] as num?)?.toInt() ?? 0,
      lastUpdatedAt: DateTimeHelper.parseOrNow(map['lastUpdatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mohsensCount': mohsensCount,
      'warningsCount': warningsCount,
      'lastUpdatedAt': lastUpdatedAt,
    };
  }

  MemberStats copyWith({
    int? mohsensCount,
    int? warningsCount,
    DateTime? lastUpdatedAt,
  }) {
    return MemberStats(
      mohsensCount: mohsensCount ?? this.mohsensCount,
      warningsCount: warningsCount ?? this.warningsCount,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberStats &&
          runtimeType == other.runtimeType &&
          mohsensCount == other.mohsensCount &&
          warningsCount == other.warningsCount &&
          lastUpdatedAt == other.lastUpdatedAt;

  @override
  int get hashCode =>
      mohsensCount.hashCode ^ warningsCount.hashCode ^ lastUpdatedAt.hashCode;

  @override
  String toString() =>
      'MemberStats(mohsensCount: $mohsensCount, warningsCount: $warningsCount, lastUpdatedAt: $lastUpdatedAt)';
}

class MemberTraits {
  final num activeness;
  final num teamwork;
  final num flexibility;
  final num goodAttitude;
  final num badAttitude;

  const MemberTraits({
    this.activeness = 0,
    this.teamwork = 0,
    this.flexibility = 0,
    this.goodAttitude = 0,
    this.badAttitude = 0,
  });

  factory MemberTraits.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const MemberTraits();
    }
    return MemberTraits(
      activeness: (map['activeness'] as num?) ?? 0,
      teamwork: (map['teamwork'] as num?) ?? 0,
      flexibility: (map['flexibility'] as num?) ?? 0,
      goodAttitude: (map['goodAttitude'] as num?) ?? 0,
      badAttitude: (map['badAttitude'] as num?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activeness': activeness,
      'teamwork': teamwork,
      'flexibility': flexibility,
      'goodAttitude': goodAttitude,
      'badAttitude': badAttitude,
    };
  }

  MemberTraits copyWith({
    num? activeness,
    num? teamwork,
    num? flexibility,
    num? goodAttitude,
    num? badAttitude,
  }) {
    return MemberTraits(
      activeness: activeness ?? this.activeness,
      teamwork: teamwork ?? this.teamwork,
      flexibility: flexibility ?? this.flexibility,
      goodAttitude: goodAttitude ?? this.goodAttitude,
      badAttitude: badAttitude ?? this.badAttitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberTraits &&
          runtimeType == other.runtimeType &&
          activeness == other.activeness &&
          teamwork == other.teamwork &&
          flexibility == other.flexibility &&
          goodAttitude == other.goodAttitude &&
          badAttitude == other.badAttitude;

  @override
  int get hashCode =>
      activeness.hashCode ^
      teamwork.hashCode ^
      flexibility.hashCode ^
      goodAttitude.hashCode ^
      badAttitude.hashCode;

  @override
  String toString() =>
      'MemberTraits(activeness: $activeness, teamwork: $teamwork, flexibility: $flexibility, goodAttitude: $goodAttitude, badAttitude: $badAttitude)';
}

class MemberModel {
  final String userId;
  final String displayName;
  final MemberRole role;
  final DateTime joinedAt;
  final bool isActive;
  final MemberStats stats;
  final MemberTraits traits;
  final String? committeeId;
  final DateTime? lastSeenNotificationsAt;

  const MemberModel({
    required this.userId,
    required this.displayName,
    required this.role,
    required this.joinedAt,
    this.isActive = true,
    required this.stats,
    this.traits = const MemberTraits(),
    this.committeeId,
    this.lastSeenNotificationsAt,
  });

  factory MemberModel.fromMap(
    Map<String, dynamic> map, {
    String? userId,
    String? committeeId,
  }) {
    return MemberModel(
      userId: userId ?? (map['userId'] as String? ?? ''),
      displayName: map['displayName'] as String? ?? '',
      role: MemberRole.fromString(map['role'] as String?),
      joinedAt: DateTimeHelper.parseOrNow(map['joinedAt']),
      isActive: map['isActive'] as bool? ?? true,
      stats: MemberStats.fromMap(map['stats'] as Map<String, dynamic>?),
      traits: MemberTraits.fromMap(map['traits'] as Map<String, dynamic>?),
      committeeId: committeeId ?? map['committeeId'] as String?,
      lastSeenNotificationsAt: map['lastSeenNotificationsAt'] != null
          ? DateTimeHelper.parseOrNow(map['lastSeenNotificationsAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'role': role.value,
      'joinedAt': joinedAt,
      'isActive': isActive,
      'stats': stats.toMap(),
      'traits': traits.toMap(),
      if (committeeId != null) 'committeeId': committeeId,
      if (lastSeenNotificationsAt != null)
        'lastSeenNotificationsAt': lastSeenNotificationsAt,
    };
  }

  MemberModel copyWith({
    String? userId,
    String? displayName,
    MemberRole? role,
    DateTime? joinedAt,
    bool? isActive,
    MemberStats? stats,
    MemberTraits? traits,
    String? committeeId,
    DateTime? lastSeenNotificationsAt,
  }) {
    return MemberModel(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
      stats: stats ?? this.stats,
      traits: traits ?? this.traits,
      committeeId: committeeId ?? this.committeeId,
      lastSeenNotificationsAt:
          lastSeenNotificationsAt ?? this.lastSeenNotificationsAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          role == other.role &&
          joinedAt == other.joinedAt &&
          isActive == other.isActive &&
          stats == other.stats &&
          traits == other.traits &&
          committeeId == other.committeeId &&
          lastSeenNotificationsAt == other.lastSeenNotificationsAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      displayName.hashCode ^
      role.hashCode ^
      joinedAt.hashCode ^
      isActive.hashCode ^
      stats.hashCode ^
      traits.hashCode ^
      committeeId.hashCode ^
      lastSeenNotificationsAt.hashCode;

  @override
  String toString() =>
      'MemberModel(userId: $userId, displayName: $displayName, role: ${role.value}, joinedAt: $joinedAt, isActive: $isActive, stats: $stats, traits: $traits, committeeId: $committeeId, lastSeenNotificationsAt: $lastSeenNotificationsAt)';
}
