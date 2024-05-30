import 'dart:async';

import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/messenger/models/dialog_model.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/domain/messenger/usecases/create_dialog.dart';
import 'package:chatter/features/domain/messenger/usecases/delete_dialog.dart';
import 'package:chatter/features/domain/messenger/usecases/get_dialogs_list.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dialogs_list_event.dart';
part 'dialogs_list_state.dart';

class DialogsListBloc extends Bloc<DialogsListEvent, DialogsListState> {
  final GetDialogsListUsecase getDialogsList;
  final CreateDialogUseCase createDialog;
  final DeleteDialogUseCase deleteDialog;

  DialogsListBloc({
    required this.getDialogsList,
    required this.createDialog,
    required this.deleteDialog,
  }) : super(const DialogsListState()) {
    on<DialogsListFetch>(_onDialogsListFetch);
    on<DialogsListComplete>(_onDialogsListComplete);
    on<DialogsListAdd>(_onDialogsListAdd);
    on<DialogsListDelete>(_onDialogsListDelete);

    // Initialize dialog stream subscription
    final userId = sl.get<AuthenticationBloc>().currentUser.id;

    FirebaseFirestore.instance
        .collection('/dialogs')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessage.createdTimestamp', descending: true)
        .snapshots()
        .listen((final snapshot) async {
      if (isClosed) return;
      if (snapshot.docs.isNotEmpty) {
        final dialogs = (await Future.wait(snapshot.docs.map(
          (final doc) async {
            final dialogWithId = doc.data()['participants'].firstWhere((e) {
              return e != userId;
            });

            final dialogWith = await FirebaseFirestore.instance
                .collection('/users')
                .doc(dialogWithId)
                .get();

            return DialogModel.fromJson(
                json: doc.data()
                  ..addAll({
                    'id': doc.id,
                    'dialogWith': UserModel.fromJson(json: dialogWith.data()!)
                  }));
          },
        )))
            .toList();

        add(DialogsListComplete(dialogs: dialogs.toList()));
      } else {
        add(const DialogsListComplete(dialogs: []));
      }
    });
  }

  List<DialogEntity> get dialogs {
    if (state.dialogs != null) return state.dialogs!;

    throw Exception('Dialogs not define*d at this moment!');
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
  ) async {
    emit(DialogsListState(
      dialogs: event.dialogs,
      message: '',
      status: DialogsListStatus.success,
    ));
  }

  Future<void> _onDialogsListDelete(
    final DialogsListDelete event,
    final Emitter<DialogsListState> emit,
  ) async {
    final dialogsOrFailure = await deleteDialog(DeleteDialogParams(
      dialogId: event.dialogId,
    ));

    dialogsOrFailure.fold(
      (_) => null, // add(DialogsListFetch(user: event.user)),
      (final failure) => emit(DialogsListState(
        message: failure.message,
        status: DialogsListStatus.failed,
      )),
    );
  }

  Future<void> _onDialogsListAdd(
    final DialogsListAdd event,
    final Emitter<DialogsListState> emit,
  ) async {
    final dialogsOrFailure = await createDialog(CreateDialogParams(
      user: event.user,
      dialogWith: event.dialogWith,
    ));

    dialogsOrFailure.fold(
      (_) => null, // add(DialogsListFetch(user: event.user)),
      (final failure) => emit(DialogsListState(
        message: failure.message,
        status: DialogsListStatus.failed,
      )),
    );
  }
}
