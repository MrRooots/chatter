import 'dart:async';

import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/usecases/update_password.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_password_event.dart';
part 'edit_password_state.dart';

class EditPasswordBloc extends Bloc<EditPasswordEvent, EditPasswordState> {
  final UpdatePasswordUsecase updatePassword;

  EditPasswordBloc({required this.updatePassword})
      : super(const EditPasswordState()) {
    on<EditPasswordStart>(_onEditPasswordStart);
    on<EditPasswordComplete>(_onEditPasswordComplete);
  }

  Future<void> _onEditPasswordStart(
    final EditPasswordStart event,
    final Emitter<EditPasswordState> emit,
  ) async {
    if (!event.isValid) {
      return emit(const EditPasswordState(
          status: EditPasswordStatus.failed,
          message: 'Passwords doesnt match, or current password is invalid!'));
    }

    emit(const EditPasswordState(status: EditPasswordStatus.loading));

    final failureOrUpdatedUser = await updatePassword(UpdatePasswordParams(
      user: event.user,
      oldPassword: event.currentPassword,
      newPassword: event.newPassword,
    ));

    failureOrUpdatedUser.fold(
      (final user) => emit(state.copyWith(
        user: user,
        message: '',
        status: EditPasswordStatus.success,
      )),
      (final failure) => emit(EditPasswordState(
        message: failure.message,
        status: EditPasswordStatus.failed,
      )),
    );
  }

  void _onEditPasswordComplete(final EditPasswordComplete event,
          final Emitter<EditPasswordState> emit) =>
      emit(const EditPasswordState());
}
