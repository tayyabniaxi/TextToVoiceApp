// subscription_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/bloc/subscription_event.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/bloc/subscription_state.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/subscription_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionState()) {
    on<StartFreeTrial>(_onStartFreeTrial);
    on<UnlockYearlySubscription>(_onUnlockYearly);
    on<CheckSubscriptionStatus>(_onCheckStatus);
  }

  void _onStartFreeTrial(
      StartFreeTrial event, Emitter<SubscriptionState> emit) {}

  void _onUnlockYearly(
      UnlockYearlySubscription event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(isYearlyPlan: true));
  }

  void _onCheckStatus(
      CheckSubscriptionStatus event, Emitter<SubscriptionState> emit) {}
}
