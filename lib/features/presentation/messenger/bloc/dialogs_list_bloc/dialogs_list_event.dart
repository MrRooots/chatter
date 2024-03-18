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
  const DialogsListComplete();
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
