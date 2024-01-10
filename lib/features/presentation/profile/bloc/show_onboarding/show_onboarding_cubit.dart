import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'show_onboarding_state.dart';

class ShowOnboardingCubit extends Cubit<ShowOnboardingState> {
  ShowOnboardingCubit()
      : super(const ShowOnboardingState(showOnboarding: false));

  Future<void> switchOnboarding({required final bool value}) async =>
      emit(ShowOnboardingState(showOnboarding: value));
}
