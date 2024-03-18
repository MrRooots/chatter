import 'dart:async';

import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/domain/messenger/usecases/create_dialog.dart';
import 'package:chatter/features/domain/messenger/usecases/get_dialogs_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dialogs_list_event.dart';
part 'dialogs_list_state.dart';

class DialogsListBloc extends Bloc<DialogsListEvent, DialogsListState> {
  final GetDialogsListUsecase getDialogsList;
  final CreateDialogUseCase createDialog;

  DialogsListBloc({
    required this.getDialogsList,
    required this.createDialog,
  }) : super(const DialogsListState()) {
    on<DialogsListFetch>(_onDialogsListFetch);
    on<DialogsListComplete>(_onDialogsListComplete);
    on<DialogsListAdd>(_onDialogsListAdd);
  }

  List<DialogEntity> get dialogs {
    if (state.dialogs != null) return state.dialogs!;

    throw Exception('Dialogs not defined at this moment!');
  }

  Future<void> _onDialogsListFetch(
    final DialogsListFetch event,
    final Emitter<DialogsListState> emit,
  ) async {
    emit(const DialogsListState(status: DialogsListStatus.loading));

    final dialogsOrFailure =
        await getDialogsList(GetDialogsListParams(uid: event.user.id));

    dialogsOrFailure.fold(
      (final dialogs) => emit(DialogsListState(
        dialogs: dialogs,
        status: DialogsListStatus.success,
      )),
      (final r) => emit(DialogsListState(
        message: r.message,
        status: DialogsListStatus.failed,
      )),
    );
  }

  Future<void> _onDialogsListComplete(
    final DialogsListComplete event,
    final Emitter<DialogsListState> emit,
  ) async {}

  Future<void> _onDialogsListAdd(
    final DialogsListAdd event,
    final Emitter<DialogsListState> emit,
  ) async {
    final dialogsOrFailure = await createDialog(CreateDialogParams(
      user: event.user,
      dialogWith: event.dialogWith,
    ));

    dialogsOrFailure.fold(
      (_) => add(DialogsListFetch(user: event.user)),
      (final failure) => emit(DialogsListState(
        message: failure.message,
        status: DialogsListStatus.failed,
      )),
    );
  }
}
