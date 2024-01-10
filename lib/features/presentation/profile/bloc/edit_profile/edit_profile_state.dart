part of 'edit_profile_bloc.dart';

enum EditProfileStatus { success, loading, failed, undefined }

final class EditProfileState extends Equatable {
  final String message;
  final UserEntity? user;
  final EditProfileStatus status;

  const EditProfileState({
    this.user,
    this.message = '',
    this.status = EditProfileStatus.undefined,
  });

  bool get isSuccess => status == EditProfileStatus.success;

  bool get isLoading => status == EditProfileStatus.loading;

  bool get isFailed => status == EditProfileStatus.failed;

  bool get isUndefined => status == EditProfileStatus.undefined;

  @override
  List<Object?> get props => [user, message, status];

  EditProfileState copyWith({
    final UserEntity? user,
    final String? message,
    final EditProfileStatus? status,
  }) {
    return EditProfileState(
      user: user ?? this.user,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
