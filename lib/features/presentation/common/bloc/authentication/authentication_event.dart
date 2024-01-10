part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

final class AuthenticationStart extends AuthenticationEvent {
  const AuthenticationStart();
}

final class AuthenticationAuth extends AuthenticationEvent {
  final UserEntity user;

  const AuthenticationAuth({required this.user});

  @override
  List<Object?> get props => [user];
}

final class AuthenticationUnauth extends AuthenticationEvent {
  const AuthenticationUnauth();
}

final class AuthenticationUpdated extends AuthenticationEvent {
  final UserEntity newUser;

  const AuthenticationUpdated({required this.newUser});

  @override
  List<Object?> get props => [newUser];
}
