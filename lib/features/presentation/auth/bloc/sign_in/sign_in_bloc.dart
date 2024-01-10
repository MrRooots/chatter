import 'dart:async';

import 'package:chatter/features/domain/auth/usecases/sign_in.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUserUsecase signInUser;

  SignInBloc({
    required this.signInUser,
  }) : super(const SignInState()) {
    on<SignInStart>(_onSignInStart);
    on<SignInClean>(_onSignInClean);
  }

  UserEntity get user {
    if (state.user != null) return state.user!;

    throw Exception('User not defined at this moment');
  }

  Future<void> _onSignInStart(
    final SignInStart event,
    final Emitter<SignInState> emit,
  ) async {
    if (!event.isValid) {
      emit(state.copyWith(
        message: 'All fields are required!',
        status: SignInStatus.failed,
      ));
      return;
    }

    emit(state.copyWith(message: '', status: SignInStatus.loading));

    final userOrFailure = await signInUser(SignInUserParams(
      email: event.username,
      password: event.password,
    ));
    userOrFailure.fold(
      (final user) => emit(state.copyWith(
        user: user,
        message: '',
        status: SignInStatus.success,
      )),
      (final failure) => emit(state.copyWith(
        message: failure.message,
        status: SignInStatus.failed,
      )),
    );
  }

  Future<void> _onSignInClean(
    final SignInClean event,
    final Emitter<SignInState> emit,
  ) async {
    emit(const SignInState());
  }
}
