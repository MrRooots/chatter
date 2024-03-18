part of 'dialog_bloc.dart';

enum DialogStatus { success, loading, failed, undefined }

final class DialogState extends Equatable {
  final String message;
  final List<MessageEntity>? messages;
  final DialogStatus status;

  const DialogState({
    this.messages,
    this.message = '',
    this.status = DialogStatus.undefined,
  });

  @override
  List<Object?> get props => [message, messages, status];

  bool get isSuccess => status == DialogStatus.success;

  bool get isLoading => status == DialogStatus.loading;

  bool get isFailed => status == DialogStatus.failed;

  bool get isUndefined => status == DialogStatus.undefined;
}
