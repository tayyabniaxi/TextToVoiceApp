part of 'statistic_bloc.dart';


abstract class StatisticEvent {}

class StatisticSliderValueChange extends StatisticEvent {
  final double value;

  StatisticSliderValueChange(this.value);
}
