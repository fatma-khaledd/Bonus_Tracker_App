import 'date_time_helper.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> committees;
  final String? defaultCommitteeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.committees = const [],
    this.defaultCommitteeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String? uid}) {
    return UserModel(
      uid: uid ?? (map['uid'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      committees: (map['committees'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      defaultCommitteeId: map['defaultCommitteeId'] as String?,
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
      updatedAt: DateTimeHelper.parseOrNow(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'committees': committees,
      if (defaultCommitteeId != null) 'defaultCommitteeId': defaultCommitteeId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    List<String>? committees,
    String? defaultCommitteeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      committees: committees ?? this.committees,
      defaultCommitteeId: defaultCommitteeId ?? this.defaultCommitteeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          avatarUrl == other.avatarUrl &&
          defaultCommitteeId == other.defaultCommitteeId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      avatarUrl.hashCode ^
      defaultCommitteeId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, avatarUrl: $avatarUrl, committees: $committees, defaultCommitteeId: $defaultCommitteeId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
