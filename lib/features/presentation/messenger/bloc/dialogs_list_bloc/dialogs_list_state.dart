part of 'dialogs_list_bloc.dart';

enum DialogsListStatus { success, loading, failed, undefined }

final class DialogsListState extends Equatable {
  final String message;
  final List<DialogEntity>? dialogs;
  final DialogsListStatus status;

  const DialogsListState({
    this.dialogs,
    this.message = '',
    this.status = DialogsListStatus.undefined,
  });

  @override
  List<Object?> get props => [dialogs, message, status];

  bool get isSuccess => status == DialogsListStatus.success;

  bool get isLoading => status == DialogsListStatus.loading;

  bool get isFailed => status == DialogsListStatus.failed;

  bool get isUndefined => status == DialogsListStatus.undefined;

  DialogsListState copyWith({
    final List<DialogEntity>? dialogs,
    final String? message,
    final DialogsListStatus? status,
  }) {
    return DialogsListState(
      dialogs: dialogs ?? this.dialogs,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
