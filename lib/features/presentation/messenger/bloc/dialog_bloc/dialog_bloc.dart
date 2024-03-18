import 'dart:async';

import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:chatter/features/domain/messenger/usecases/get_messages_list.dart';
import 'package:chatter/features/domain/messenger/usecases/send_message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  final GetMessagesListUsecase getMessagesList;
  final SendMessageUsecase sendMessage;

  DialogBloc({
    required this.getMessagesList,
    required this.sendMessage,
  }) : super(const DialogState()) {
    on<DialogOpen>(_onDialogOpen);
    on<DialogSendMessage>(_onDialogSendMessage);
  }

  Future<void> _onDialogOpen(
    final DialogOpen event,
    final Emitter<DialogState> emit,
  ) async {
    emit(const DialogState(status: DialogStatus.loading));

    final messagesOrFailure = await getMessagesList(GetMessagesListParams(
      userId: event.userId,
      dialogId: event.dialogId,
    ));

    messagesOrFailure.fold(
      (final messages) => emit(DialogState(
        status: DialogStatus.success,
        messages: messages,
      )),
      (final failure) => emit(DialogState(
        status: DialogStatus.failed,
        message: failure.message,
      )),
    );
  }

  Future<void> _onDialogSendMessage(
    final DialogSendMessage event,
    final Emitter<DialogState> emit,
  ) async {
    final messagesOrFailure = await sendMessage(SendMessageParams(
      dialog: event.dialog,
      currentUser: event.currentUser,
      receiptId: event.dialog.sender.id,
      message: event.message,
    ));

    messagesOrFailure.fold(
      (final messages) => emit(DialogState(
        status: DialogStatus.success,
        messages: messages,
      )),
      (final failure) => emit(DialogState(
        status: DialogStatus.failed,
        message: failure.message,
      )),
    );
  }
}
