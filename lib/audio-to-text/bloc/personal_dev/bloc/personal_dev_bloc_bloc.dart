import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/personal_dev/bloc/personal_dev_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/personal_dev/bloc/personal_dev_bloc_state.dart';
import 'package:new_wall_paper_app/model/course_model.dart';

// lib/bloc/course_bloc.dart
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<SearchCourses>(_onSearchCourses);
    on<SelectPrompt>(_onSelectPrompt);
    on<TogglePlayState>(_onTogglePlayState);
    on<ToggleHDState>(_onToggleHDState);
  }

  final List<Map<String, String>> _courseData = [
    {
      'title': 'Effective Communication',
      'description':
          'Master the art of clear and impactful communication in business and life',
      'imagePath': 'assets/icons/library.png',
    },
    {
      'title': 'Leadership Skills',
      'description':
          'Develop essential leadership qualities to inspire and guide teams',
      'imagePath': 'assets/icons/library.png',
    },
    {
      'title': 'Time Management',
      'description': 'Learn to prioritize tasks and maximize productivity',
      'imagePath': 'assets/icons/library.png',
    },
    {
      'title': 'Emotional Intelligence',
      'description': 'Understand and manage emotions for better relationships',
      'imagePath': 'assets/icons/library.png',
    },
    {
      'title': 'Critical Thinking',
      'description':
          'Enhance problem-solving abilities through structured thinking',
      'imagePath': 'assets/icons/library.png',
    },
  ];
  // Generate suggested prompts from course titles
  List<String> get _suggestedPrompts =>
      _courseData.map((data) => data['title']!).toList();

  List<Course> _allCourses = [];
  void _onLoadCourses(LoadCourses event, Emitter<CourseState> emit) {
    emit(CourseLoading());
    try {
      _allCourses = List.generate(_courseData.length, (index) {
        final courseData = _courseData[index];
        return Course(
          title: courseData['title']!,
          description: courseData['description']!,
          imagePath: courseData['imagePath']!,
        );
      });
      emit(CourseLoaded(
        courses: _allCourses,
        suggestedPrompts: _suggestedPrompts,
      ));
    } catch (e) {
      emit(CourseError('Failed to load courses: ${e.toString()}'));
    }
  }

  void _onSearchCourses(SearchCourses event, Emitter<CourseState> emit) {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(currentState.copyWith(
          courses: _allCourses,
          suggestedPrompts: _suggestedPrompts,
        ));
        return;
      }

      // Filter prompts based on query
      final filteredPrompts = _suggestedPrompts
          .where((prompt) => prompt.toLowerCase().contains(query))
          .toList();

      // Filter courses based on the same query
      final filteredCourses = _allCourses
          .where((course) => course.title.toLowerCase().contains(query))
          .toList();

      emit(currentState.copyWith(
        courses: filteredCourses,
        suggestedPrompts: filteredPrompts,
      ));
    }
  }

  void _onSelectPrompt(SelectPrompt event, Emitter<CourseState> emit) {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;
      final selectedTitle = event.prompt;

      // Filter courses to show only those matching the selected title exactly
      final filteredCourses = _allCourses
          .where((course) =>
              course.title.toLowerCase() == selectedTitle.toLowerCase())
          .toList();

      emit(currentState.copyWith(
        courses: filteredCourses,
        selectedPrompt: selectedTitle,
      ));
    }
  }

  void _onTogglePlayState(TogglePlayState event, Emitter<CourseState> emit) {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;
      final updatedCourses = List<Course>.from(currentState.courses);
      updatedCourses[event.index] = updatedCourses[event.index].copyWith(
        isPlaying: !updatedCourses[event.index].isPlaying,
      );
      emit(currentState.copyWith(courses: updatedCourses));
    }
  }

  void _onToggleHDState(ToggleHDState event, Emitter<CourseState> emit) {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;
      final updatedCourses = List<Course>.from(currentState.courses);
      updatedCourses[event.index] = updatedCourses[event.index].copyWith(
        isHDEnabled: !updatedCourses[event.index].isHDEnabled,
      );
      emit(currentState.copyWith(courses: updatedCourses));
    }
  }
}
