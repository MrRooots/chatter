part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

final class SignUpStart extends SignUpEvent {
  final String username;
  final String password;
  final String firstname;
  final String lastname;
  final String email;

  const SignUpStart({
    required this.email,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
  });

  /// Check if current event is valid
  bool get isValid {
    return email.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        firstname.isNotEmpty &&
        lastname.isNotEmpty;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [email, username, password, firstname, lastname];
}

final class SignUpClean extends SignUpEvent {
  const SignUpClean();
}
