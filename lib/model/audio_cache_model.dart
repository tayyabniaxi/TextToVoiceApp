class AudioRecording {
  int? id;
  String text;
  String filePath;
  DateTime createdAt;
  String? title;

  AudioRecording({
    this.id,
    required this.text,
    required this.filePath,
    required this.createdAt,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
    };
  }

  factory AudioRecording.fromMap(Map<String, dynamic> map) {
    return AudioRecording(
      id: map['id'],
      text: map['text'],
      filePath: map['filePath'],
      createdAt: DateTime.parse(map['createdAt']),
      title: map['title'],
    );
  }
}
