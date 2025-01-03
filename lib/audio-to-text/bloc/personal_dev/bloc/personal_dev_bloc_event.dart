import 'package:equatable/equatable.dart';

// lib/bloc/course_event.dart
import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {}

class SearchCourses extends CourseEvent {
  final String query;
  const SearchCourses(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectPrompt extends CourseEvent {
  final String prompt;
  const SelectPrompt(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

class TogglePlayState extends CourseEvent {
  final int index;
  const TogglePlayState(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleHDState extends CourseEvent {
  final int index;
  const ToggleHDState(this.index);

  @override
  List<Object?> get props => [index];
}
