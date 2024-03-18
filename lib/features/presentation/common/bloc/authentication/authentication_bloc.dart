import 'dart:async';

import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/features/domain/auth/usecases/authenticate.dart';
import 'package:chatter/features/domain/auth/usecases/sign_out.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/usecases/profile_updates_stream.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticateUserUsecase authenticateUser;
  final SignOutUserUsecase signOutUser;
  final ProfileUpdatesListenUsecase profileUpdatesListen;

  /// Subscription to user change events caused by FirebaseFirestore
  StreamSubscription<UserEntity?>? profileChangesStream;

  AuthenticationBloc({
    required this.authenticateUser,
    required this.signOutUser,
    required this.profileUpdatesListen,
  }) : super(const AuthenticationState()) {
    on<AuthenticationStart>(_onAuthenticationStart);
    on<AuthenticationAuth>(_onAuthenticationAuth);
    on<AuthenticationUnauth>(_onAuthenticationUnauth);
    on<AuthenticationUpdated>(_onAuthenticationUpdated);
  }

  @override
  Future<void> close() async {
    profileChangesStream?.cancel();
    profileChangesStream = null;
    super.close();
  }

  /// Create subscription to user data change events
  Future<void> subscribeToProfileChangeEvents() async {
    if (profileChangesStream == null) {
      try {
        final streamOrFailure = await profileUpdatesListen(
            ProfileUpdatesListenParams(user: currentUser));

        streamOrFailure.fold(
          (final stream) => profileChangesStream = stream.listen((final user) {
            if (user != null) add(AuthenticationUpdated(newUser: user));
          }),
          (r) => null,
        );
      } on Exception {
        return;
      }
    }
  }

  /// Get current authenticated user
  UserEntity get currentUser {
    if (state.user != null && state.isAuthenticated) return state.user!;

    throw Exception('User not defined at this moment!');
  }

  Future<void> _onAuthenticationStart(
    final AuthenticationStart event,
    final Emitter<AuthenticationState> emit,
  ) async {
    print('On auth start with event: ${event}');
    final userOrFailure = await authenticateUser();

    userOrFailure.fold(
      (final user) => emit(state.copyWith(
        user: user,
        message: '',
        status: AuthenticationStatus.authenticated,
      )),
      (final Failure failure) {
        emit(AuthenticationState(
          status: failure is AuthorizationFailure
              ? failure.isFirstLaunch
                  ? AuthenticationStatus.firstLaunch
                  : AuthenticationStatus.unauthenticated
              : AuthenticationStatus.unauthenticated,
        ));
      },
    );
  }

  Future<void> _onAuthenticationAuth(
    final AuthenticationAuth event,
    final Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(
      user: event.user,
      status: AuthenticationStatus.authenticated,
    ));
  }

  Future<void> _onAuthenticationUnauth(
    final AuthenticationUnauth event,
    final Emitter<AuthenticationState> emit,
  ) async {
    await signOutUser();

    emit(const AuthenticationState(
      status: AuthenticationStatus.unauthenticated,
    ));
  }

  Future<void> _onAuthenticationUpdated(
    final AuthenticationUpdated event,
    final Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationState(
      status: AuthenticationStatus.authenticated,
      user: event.newUser,
    ));
  }
}
