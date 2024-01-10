part of 'show_onboarding_cubit.dart';

final class ShowOnboardingState extends Equatable {
  final bool showOnboarding;

  const ShowOnboardingState({required this.showOnboarding});

  @override
  List<Object> get props => [showOnboarding];
}
