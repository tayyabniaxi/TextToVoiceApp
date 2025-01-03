// bottom_navigation_event.dart
import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();
  
  @override
  List<Object> get props => [];
}

class NavigateToPage extends BottomNavigationEvent {
  final int pageIndex;

  const NavigateToPage(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
