import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';

class CategoryData {
  final Map<String, List<TrendingSection>> categorySections = {
    'Self Growth': [
      TrendingSection(
          title: 'Personal Development', icon: AppImage.dev, items: []),
      TrendingSection(
          title: 'Invest & Trending', icon: AppImage.dolor, items: []),
      TrendingSection(title: 'Time Management', icon: AppImage.time, items: []),
      TrendingSection(
          title: 'Personal Finance', icon: AppImage.wallet, items: []),
    ],
    'Self Care': [
      TrendingSection(title: 'Mindfulness', icon: AppImage.wallet, items: []),
      TrendingSection(
          title: 'Stress Management', icon: AppImage.wallet, items: []),
      TrendingSection(
          title: 'Work-Life Balance', icon: AppImage.wallet, items: []),
    ],
    'Health': [
      TrendingSection(title: 'Exercise', icon: AppImage.wallet, items: []),
      TrendingSection(title: 'Nutrition', icon: AppImage.wallet, items: []),
      TrendingSection(title: 'Sleep', icon: AppImage.wallet, items: []),
    ],
    'Family': [
      TrendingSection(title: 'Parenting', icon: AppImage.wallet, items: []),
      TrendingSection(title: 'Relationships', icon: AppImage.wallet, items: []),
      TrendingSection(
          title: 'Home Management', icon: AppImage.wallet, items: []),
    ],
  };
}

class TrendingSection {
  final String title;
  final String icon;
  final List<String> items;

  TrendingSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}
