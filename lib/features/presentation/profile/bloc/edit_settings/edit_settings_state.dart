part of 'edit_settings_bloc.dart';

enum EditSettingsStatus { success, loading, failed, undefined }

final class EditSettingsState extends Equatable {
  final String message;
  final UserEntity? user;
  final EditSettingsStatus status;

  const EditSettingsState({
    this.user,
    this.message = '',
    this.status = EditSettingsStatus.undefined,
  });

  bool get isSuccess => status == EditSettingsStatus.success;

  bool get isLoading => status == EditSettingsStatus.loading;

  bool get isFailed => status == EditSettingsStatus.failed;

  bool get isUndefined => status == EditSettingsStatus.undefined;

  @override
  List<Object?> get props => [user, message, status];

  EditSettingsState copyWith({
    final UserEntity? user,
    final String? message,
    final EditSettingsStatus? status,
  }) {
    return EditSettingsState(
      user: user ?? this.user,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
