abstract class StatisticState {}

class StatisticSldierValueInitial extends StatisticState {}

class StatisticSliderValueChangeState extends StatisticState {
  double value;
  StatisticSliderValueChangeState(this.value);
}
abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderValueChangedState extends SliderState {
  final double value;

  SliderValueChangedState(this.value);
}