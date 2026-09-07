import 'date_time_helper.dart';

enum NoteType {
  personal('personal'),
  hr('hr');

  final String value;
  const NoteType(this.value);

  static NoteType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'hr':
        return NoteType.hr;
      case 'personal':
      default:
        return NoteType.personal;
    }
  }
}

class NoteModel {
  final String id;
  final String ownerId;
  final String? committeeId;
  final NoteType type;
  final String title;
  final String content;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.ownerId,
    this.committeeId,
    required this.type,
    required this.title,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return NoteModel(
      id: id ?? (map['id'] as String? ?? ''),
      ownerId: map['ownerId'] as String? ?? '',
      committeeId: map['committeeId'] as String?,
      type: NoteType.fromString(map['type'] as String?),
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      isDone: map['isDone'] as bool? ?? false,
      createdAt: DateTimeHelper.parseOrNow(map['createdAt']),
      updatedAt: DateTimeHelper.parseOrNow(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'committeeId': committeeId,
      'type': type.value,
      'title': title,
      'content': content,
      'isDone': isDone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  NoteModel copyWith({
    String? id,
    String? ownerId,
    String? committeeId,
    NoteType? type,
    String? title,
    String? content,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      committeeId: committeeId ?? this.committeeId,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ownerId == other.ownerId &&
          committeeId == other.committeeId &&
          type == other.type &&
          title == other.title &&
          content == other.content &&
          isDone == other.isDone &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      ownerId.hashCode ^
      committeeId.hashCode ^
      type.hashCode ^
      title.hashCode ^
      content.hashCode ^
      isDone.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'NoteModel(id: $id, ownerId: $ownerId, committeeId: $committeeId, type: ${type.value}, title: $title, content: $content, isDone: $isDone, createdAt: $createdAt, updatedAt: $updatedAt)';
}
