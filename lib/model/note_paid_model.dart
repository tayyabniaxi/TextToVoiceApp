// note_model.dart
class Note {
  String id;
  String title;
  String content;
  DateTime dateTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
  });

  Note copy({
    String? id,
    String? title,
    String? content,
    DateTime? dateTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        dateTime: dateTime ?? this.dateTime,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'dateTime': dateTime.toIso8601String(),
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        dateTime: DateTime.parse(json['dateTime']),
      );
}
