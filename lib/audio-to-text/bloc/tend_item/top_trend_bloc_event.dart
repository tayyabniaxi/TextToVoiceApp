abstract class TrendingEvent {}

class LoadTrendingData extends TrendingEvent {}

class SelectCategory extends TrendingEvent {
  final String category;
  SelectCategory(this.category);
}

class NavigateToSection extends TrendingEvent {
  final String section;
  NavigateToSection(this.section);
}