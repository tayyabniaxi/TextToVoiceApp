// trending_state.dart
import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/model/home_top_trending_item.dart';

// trending_state.dart
class TrendingState {
  final List<String> categories;
  final String selectedCategory;
  final List<TrendingSection> sections;
  final bool isLoading;

  TrendingState({
    this.categories = const [],
    this.selectedCategory = '',
    this.sections = const [],
    this.isLoading = false,
  });

  TrendingState copyWith({
    List<String>? categories,
    String? selectedCategory,
    List<TrendingSection>? sections,
    bool? isLoading,
  }) {
    return TrendingState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}