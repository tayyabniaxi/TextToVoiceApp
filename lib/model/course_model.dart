// lib/models/course_model.dart
import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String title;
  final String description;
  final String imagePath;
  final bool isPlaying;
  final bool isHDEnabled;

  const Course({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isPlaying = false,
    this.isHDEnabled = false,
  });

  Course copyWith({
    String? title,
    String? description,
    String? imagePath,
    bool? isPlaying,
    bool? isHDEnabled,
  }) {
    return Course(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isPlaying: isPlaying ?? this.isPlaying,
      isHDEnabled: isHDEnabled ?? this.isHDEnabled,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        imagePath,
        isPlaying,
        isHDEnabled,
      ];
}

// lib/models/prompt_data.dart
class PromptData {
  final String title;
  final String content;
  final String type;
  final int index;
  final Map<String, dynamic>? additionalData;

  PromptData({
    required this.title,
    required this.content,
    required this.type,
    required this.index,
    this.additionalData,
  });

  // Convert to Map for easier data passing
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'type': type,
      'index': index,
      'additionalData': additionalData,
    };
  }

  // Create from Map for data retrieval
  factory PromptData.fromMap(Map<String, dynamic> map) {
    return PromptData(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: map['type'] ?? '',
      index: map['index'] ?? 0,
      additionalData: map['additionalData'],
    );
  }
}
