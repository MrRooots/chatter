part of 'edit_password_bloc.dart';

enum EditPasswordStatus { success, loading, failed, undefined }

final class EditPasswordState extends Equatable {
  final String message;
  final UserEntity? user;
  final EditPasswordStatus status;

  const EditPasswordState({
    this.user,
    this.message = '',
    this.status = EditPasswordStatus.undefined,
  });

  bool get isSuccess => status == EditPasswordStatus.success;

  bool get isLoading => status == EditPasswordStatus.loading;

  bool get isFailed => status == EditPasswordStatus.failed;

  bool get isUndefined => status == EditPasswordStatus.undefined;

  @override
  List<Object?> get props => [user, message, status];

  EditPasswordState copyWith({
    final UserEntity? user,
    final String? message,
    final EditPasswordStatus? status,
  }) {
    return EditPasswordState(
      user: user ?? this.user,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
