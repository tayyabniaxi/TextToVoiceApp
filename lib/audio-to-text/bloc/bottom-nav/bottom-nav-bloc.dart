// bottom_navigation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/bottom-nav/bottom-nav-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/bottom-nav/bottom-nav-state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(const BottomNavigationState()) {
    on<NavigateToPage>((event, emit) {
      emit(BottomNavigationState(selectedIndex: event.pageIndex));
    });
  }
}
