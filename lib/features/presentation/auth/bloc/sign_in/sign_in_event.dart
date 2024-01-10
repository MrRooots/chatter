part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

final class SignInStart extends SignInEvent {
  final String username;
  final String password;

  const SignInStart({required this.username, required this.password});

  bool get isValid => username.isNotEmpty && password.isNotEmpty;

  @override
  List<Object?> get props => [username, password];
}

final class SignInClean extends SignInEvent {
  const SignInClean();
}
