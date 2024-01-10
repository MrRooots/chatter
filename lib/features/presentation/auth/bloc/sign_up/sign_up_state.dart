part of 'sign_up_bloc.dart';

enum SignUpStatus { success, loading, failed, undefined }

final class SignUpState extends Equatable {
  final String message;
  final UserEntity? user;
  final SignUpStatus status;

  const SignUpState({
    this.user,
    this.message = '',
    this.status = SignUpStatus.undefined,
  });

  bool get isSuccess => status == SignUpStatus.success;

  bool get isLoading => status == SignUpStatus.loading;

  bool get isFailed => status == SignUpStatus.failed;

  bool get isUndefined => status == SignUpStatus.undefined;

  SignUpState copyWith({
    final SignUpStatus? status,
    final UserEntity? user,
    final String? message,
  }) {
    return SignUpState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [message, status, user];
}
