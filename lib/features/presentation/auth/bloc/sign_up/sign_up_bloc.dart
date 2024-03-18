import 'dart:async';

import 'package:chatter/features/domain/auth/usecases/sign_up.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUserUsecase signUp;

  SignUpBloc({required this.signUp}) : super(const SignUpState()) {
    on<SignUpStart>(_onSignUpStart);
    on<SignUpClean>(_onSignUpClean);
  }

  Future<void> _onSignUpStart(
    final SignUpStart event,
    final Emitter<SignUpState> emit,
  ) async {
    if (!event.isValid) {
      return emit(const SignUpState(
        message: 'All fields are required!',
        status: SignUpStatus.failed,
      ));
    }

    emit(state.copyWith(message: '', status: SignUpStatus.loading));
    print(event);
    final failureOrUser = await signUp(SignUpUserParams(
      username: event.username,
      password: event.password,
      firstname: event.firstname,
      lastname: event.lastname,
      email: event.email,
    ));

    failureOrUser.fold(
      (final user) => emit(SignUpState(
        user: user,
        status: SignUpStatus.success,
      )),
      (final failure) => emit(state.copyWith(
        message: failure.message,
        status: SignUpStatus.failed,
      )),
    );
  }

  Future<void> _onSignUpClean(
    final SignUpClean event,
    final Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpState());
  }
}
