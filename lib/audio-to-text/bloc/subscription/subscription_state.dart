
// subscription_state.dart
class SubscriptionState {
  final bool isSubscribed;
  final bool isYearlyPlan;
  final double weeklyPrice;
  final double yearlyPrice;
  final int trialDays;

  SubscriptionState({
    this.isSubscribed = false,
    this.isYearlyPlan = false,
    this.weeklyPrice = 1399.99,
    this.yearlyPrice = 1109.99,
    this.trialDays = 3,
  });

  SubscriptionState copyWith({
    bool? isSubscribed,
    bool? isYearlyPlan,
    double? weeklyPrice,
    double? yearlyPrice,
    int? trialDays,
  }) {
    return SubscriptionState(
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isYearlyPlan: isYearlyPlan ?? this.isYearlyPlan,
      weeklyPrice: weeklyPrice ?? this.weeklyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      trialDays: trialDays ?? this.trialDays,
    );
  }
}