// bottom_navigation_state.dart
import 'package:equatable/equatable.dart';

class BottomNavigationState extends Equatable {
  final int selectedIndex;

  const BottomNavigationState({this.selectedIndex = 0});

  @override
  List<Object> get props => [selectedIndex];
}
