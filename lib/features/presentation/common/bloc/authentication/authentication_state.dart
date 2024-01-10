part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  undefined,
  firstLaunch,
}

final class AuthenticationState extends Equatable {
  final UserEntity? user;
  final AuthenticationStatus status;

  const AuthenticationState({
    this.user,
    this.status = AuthenticationStatus.undefined,
  });

  bool get isAuthenticated => status == AuthenticationStatus.authenticated;

  bool get isUnauthenticated => status == AuthenticationStatus.unauthenticated;

  bool get isFirstLaunch => status == AuthenticationStatus.firstLaunch;

  bool get isUndefined => status == AuthenticationStatus.undefined;

  AuthenticationState copyWith({
    final AuthenticationStatus? status,
    final UserEntity? user,
    final String? message,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
