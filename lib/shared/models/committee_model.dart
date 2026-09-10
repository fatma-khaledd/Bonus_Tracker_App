import 'date_time_helper.dart';

class CommitteeModel {
  final String id;
  final String name;
  final DateTime createdAt;

  const CommitteeModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory CommitteeModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CommitteeModel(
      id: id ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'createdAt': createdAt};
  }

  CommitteeModel copyWith({String? id, String? name, DateTime? createdAt}) {
    return CommitteeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitteeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode;

  @override
  String toString() =>
      'CommitteeModel(id: $id, name: $name, createdAt: $createdAt)';
}
