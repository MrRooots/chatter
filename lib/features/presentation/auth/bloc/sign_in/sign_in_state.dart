part of 'sign_in_bloc.dart';

enum SignInStatus { success, loading, failed, undefined }

final class SignInState extends Equatable {
  final String message;
  final UserEntity? user;
  final SignInStatus status;

  const SignInState({
    this.user,
    this.message = '',
    this.status = SignInStatus.undefined,
  });

  bool get isSuccess => status == SignInStatus.success;

  bool get isLoading => status == SignInStatus.loading;

  bool get isFailed => status == SignInStatus.failed;

  bool get isUndefined => status == SignInStatus.undefined;

  SignInState copyWith({
    final SignInStatus? status,
    final UserEntity? user,
    final String? message,
  }) {
    return SignInState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [message, status, user];
}
