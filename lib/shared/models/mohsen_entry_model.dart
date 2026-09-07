import 'date_time_helper.dart';

enum MohsenType {
  mohsen('mohsen'),
  warning('warning');

  final String value;
  const MohsenType(this.value);

  static MohsenType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'warning':
        return MohsenType.warning;
      case 'mohsen':
      default:
        return MohsenType.mohsen;
    }
  }
}

class MohsenEntryModel {
  final String id;
  final String? memberId;
  final String? committeeId;
  final MohsenType type;
  final num value;
  final String reason;
  final String addedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MohsenEntryModel({
    required this.id,
    this.memberId,
    this.committeeId,
    required this.type,
    required this.value,
    required this.reason,
    required this.addedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MohsenEntryModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
    String? memberId,
    String? committeeId,
  }) {
    return MohsenEntryModel(
      id: id ?? (map['id'] as String? ?? ''),
      memberId: memberId ?? map['memberId'] as String?,
      committeeId: committeeId ?? map['committeeId'] as String?,
      type: MohsenType.fromString(map['type'] as String?),
      value: (map['value'] as num?) ?? 0,
      reason: map['reason'] as String? ?? '',
      addedBy: map['addedBy'] as String? ?? '',
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
      updatedAt: DateTimeHelper.parseOrNow(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (memberId != null) 'memberId': memberId,
      if (committeeId != null) 'committeeId': committeeId,
      'type': type.value,
      'value': value,
      'reason': reason,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  MohsenEntryModel copyWith({
    String? id,
    String? memberId,
    String? committeeId,
    MohsenType? type,
    num? value,
    String? reason,
    String? addedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MohsenEntryModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      committeeId: committeeId ?? this.committeeId,
      type: type ?? this.type,
      value: value ?? this.value,
      reason: reason ?? this.reason,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MohsenEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          memberId == other.memberId &&
          committeeId == other.committeeId &&
          type == other.type &&
          value == other.value &&
          reason == other.reason &&
          addedBy == other.addedBy &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      memberId.hashCode ^
      committeeId.hashCode ^
      type.hashCode ^
      value.hashCode ^
      reason.hashCode ^
      addedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'MohsenEntryModel(id: $id, memberId: $memberId, committeeId: $committeeId, type: ${type.value}, value: $value, reason: $reason, addedBy: $addedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}
