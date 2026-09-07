import 'date_time_helper.dart';

class EventModel {
  final String id;
  final String? committeeId;
  final String title;
  final String description;
  final DateTime date;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    this.committeeId,
    required this.title,
    required this.description,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
    String? committeeId,
  }) {
    return EventModel(
      id: id ?? (map['id'] as String? ?? ''),
      committeeId: committeeId ?? map['committeeId'] as String?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: DateTimeHelper.parseOrNow(map['date']),
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
      updatedAt: DateTimeHelper.parseOrNow(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (committeeId != null) 'committeeId': committeeId,
      'title': title,
      'description': description,
      'date': date,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  EventModel copyWith({
    String? id,
    String? committeeId,
    String? title,
    String? description,
    DateTime? date,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      committeeId: committeeId ?? this.committeeId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          committeeId == other.committeeId &&
          title == other.title &&
          description == other.description &&
          date == other.date &&
          createdBy == other.createdBy &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      committeeId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      date.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'EventModel(id: $id, committeeId: $committeeId, title: $title, description: $description, date: $date, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}
