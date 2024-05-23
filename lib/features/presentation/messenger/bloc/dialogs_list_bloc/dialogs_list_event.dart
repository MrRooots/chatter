part of 'dialogs_list_bloc.dart';

abstract class DialogsListEvent extends Equatable {
  const DialogsListEvent();

  @override
  List<Object?> get props => [];
}

final class DialogsListFetch extends DialogsListEvent {
  final UserEntity user;

  const DialogsListFetch({required this.user});

  @override
  List<Object?> get props => [user];
}

final class DialogsListComplete extends DialogsListEvent {
  final List<DialogEntity> dialogs;

  const DialogsListComplete({required this.dialogs});

  @override
  List<Object?> get props => [dialogs];
}

final class DialogsListAdd extends DialogsListEvent {
  final UserEntity user;
  final String dialogWith;

  const DialogsListAdd({
    required this.user,
    required this.dialogWith,
  });

  @override
  List<Object?> get props => [user, dialogWith];
}

final class DialogsListDelete extends DialogsListEvent {
  final UserEntity user;
  final String dialogId;

  const DialogsListDelete({
    required this.dialogId,
    required this.user,
  });

  @override
  List<Object?> get props => [user, dialogId];
}
