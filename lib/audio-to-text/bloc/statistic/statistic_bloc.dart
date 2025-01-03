import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/statistic/statistic_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/statistic/statistic_state.dart';

abstract class StatisticEvent {}

class StatisticSliderValueChange extends StatisticEvent {
  final double value;

  StatisticSliderValueChange(this.value);
}

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(StatisticSldierValueInitial()) {
    on<StatisticSliderValueChange>(_onSliderValueChanged);
  }

  void _onSliderValueChanged(
      StatisticSliderValueChange event, Emitter<StatisticState> emit) {
    // When the value of the slider changes, emit a new state with the updated value
    emit(StatisticSliderValueChangeState(event.value));
  }
}
