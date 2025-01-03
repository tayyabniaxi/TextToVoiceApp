// course_state.dart
import 'package:equatable/equatable.dart';
import 'package:new_wall_paper_app/audio-to-text/page/personal_development_screen.dart';
// lib/bloc/course_state.dart
import 'package:equatable/equatable.dart';
import 'package:new_wall_paper_app/model/course_model.dart';
// import '../models/course_model.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  final List<String> suggestedPrompts;
  final String selectedPrompt;

  const CourseLoaded({
    required this.courses,
    required this.suggestedPrompts,
    this.selectedPrompt = '',
  });

  CourseLoaded copyWith({
    List<Course>? courses,
    List<String>? suggestedPrompts,
    String? selectedPrompt,
  }) {
    return CourseLoaded(
      courses: courses ?? this.courses,
      suggestedPrompts: suggestedPrompts ?? this.suggestedPrompts,
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
    );
  }

  @override
  List<Object?> get props => [courses, suggestedPrompts, selectedPrompt];
}

class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object?> get props => [message];
}