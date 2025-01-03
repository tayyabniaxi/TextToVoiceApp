// trending_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_state.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/bloc/top_trend_bloc_state.dart';
import 'package:new_wall_paper_app/model/home_top_trending_item.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';

import 'top_trend_bloc_event.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final Map<String, List<TrendingSection>> categorySections = {
    'Self Growth': [
      TrendingSection(
          title: 'Personal Development',
          icon: AppImage.dev,
          items: ['Goal Setting', 'Habit Formation', 'Personal Growth Plan']),
      TrendingSection(title: 'Career Growth', icon: AppImage.dolor, items: [
        'Professional Skills',
        'Leadership Development',
        'Career Planning'
      ]),
      TrendingSection(
          title: 'Time Management',
          icon: AppImage.time,
          items: ['Productivity Tips', 'Task Prioritization', 'Time Tracking']),
      TrendingSection(
          title: 'Personal Finance',
          icon: AppImage.wallet,
          items: ['Productivity Tips', 'Task Prioritization', 'Time Tracking']),
    ],
    'Self Care': [
      TrendingSection(
          title: 'Mental Wellness',
          icon: AppImage.dolor,
          items: ['Stress Management', 'Meditation', 'Journal Prompts']),
      TrendingSection(title: 'Physical Health', icon: AppImage.dolor, items: [
        'Exercise Routines',
        'Healthy Recipes',
        'Sleep Optimization'
      ]),
      TrendingSection(
          title: 'Mindfulness',
          icon: AppImage.dolor,
          items: ['Daily Practice', 'Breathing Exercises', 'Mindful Living']),
    ],
    'Health': [
      TrendingSection(
          title: 'Fitness',
          icon: AppImage.dolor,
          items: ['Workout Plans', 'Exercise Library', 'Fitness Tracking']),
      TrendingSection(
          title: 'Nutrition',
          icon: AppImage.dolor,
          items: ['Meal Planning', 'Nutritional Guides', 'Diet Tips']),
      TrendingSection(
          title: 'Wellness',
          icon: AppImage.dolor,
          items: ['Health Checkups', 'Preventive Care', 'Lifestyle Changes']),
    ],
    'Family': [
      TrendingSection(title: 'Parenting', icon: AppImage.dolor, items: [
        'Child Development',
        'Education Support',
        'Family Activities'
      ]),
      TrendingSection(title: 'Relationships', icon: AppImage.dolor, items: [
        'Communication Skills',
        'Quality Time',
        'Conflict Resolution'
      ]),
      TrendingSection(
          title: 'Home Management',
          icon: AppImage.dolor,
          items: ['Organization Tips', 'Family Planning', 'Household Budget']),
    ],
  };

  TrendingBloc() : super(TrendingState()) {
    on<LoadTrendingData>(_onLoadTrendingData);
    on<SelectCategory>(_onSelectCategory);
    on<NavigateToSection>(_onNavigateToSection);
  }

  void _onLoadTrendingData(
      LoadTrendingData event, Emitter<TrendingState> emit) {
    emit(state.copyWith(isLoading: true));

    final categories = categorySections.keys.toList();
    final initialCategory = categories.first;
    final initialSections = categorySections[initialCategory] ?? [];

    emit(state.copyWith(
      categories: categories,
      selectedCategory: initialCategory,
      sections: initialSections,
      isLoading: false,
    ));
  }

  void _onSelectCategory(SelectCategory event, Emitter<TrendingState> emit) {
    final sections = categorySections[event.category] ?? [];
    emit(state.copyWith(
      selectedCategory: event.category,
      sections: sections,
    ));
  }

  void _onNavigateToSection(
      NavigateToSection event, Emitter<TrendingState> emit) {
    // Navigation logic
  }
}
