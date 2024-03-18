part of 'dialog_bloc.dart';

sealed class DialogEvent extends Equatable {
  const DialogEvent();

  @override
  List<Object?> get props => [];
}

final class DialogOpen extends DialogEvent {
  final String userId;
  final String dialogId;
  final UserEntity sender;

  const DialogOpen({
    required this.userId,
    required this.dialogId,
    required this.sender,
  });

  @override
  List<Object?> get props => [userId, dialogId, sender];
}

final class DialogRefresh extends DialogEvent {
  final String userId;
  final String dialogId;

  const DialogRefresh({required this.userId, required this.dialogId});

  @override
  List<Object?> get props => [userId, dialogId];
}

final class DialogSendMessage extends DialogEvent {
  final String message;

  final DialogEntity dialog;

  final UserEntity currentUser;

  const DialogSendMessage({
    required this.message,
    required this.dialog,
    required this.currentUser,
  });

  @override
  List<Object?> get props => [message, dialog, currentUser];
}
