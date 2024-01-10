import 'dart:async';

import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/common/models/user_settings_model.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/usecases/update_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_settings_event.dart';
part 'edit_settings_state.dart';

class EditSettingsBloc extends Bloc<EditSettingsEvent, EditSettingsState> {
  final UpdateProfileUsecase updateProfile;

  EditSettingsBloc({required this.updateProfile})
      : super(const EditSettingsState()) {
    on<EditSettingsStart>(_onSettingsStart);
    on<EditSettingsComplete>(_onSettingsComplete);
  }

  Future<void> _onSettingsStart(
    final EditSettingsStart event,
    final Emitter<EditSettingsState> emit,
  ) async {
    emit(const EditSettingsState(status: EditSettingsStatus.loading));

    final UserEntity newUser = (event.user as UserModel).copyWith(
      settings: UserSettingsModel(
        darkTheme: event.darkTheme,
        showOnboarding: event.showOnboarding,
        receiveNotifications: event.receiveNotifications,
      ),
    );

    final failureOrUpdatedUser =
        await updateProfile(UpdateProfileParams(user: newUser));

    failureOrUpdatedUser.fold(
      (final user) {
        emit(state.copyWith(
          user: user,
          message: '',
          status: EditSettingsStatus.success,
        ));
      },
      (final failure) => emit(EditSettingsState(
        message: failure.message,
        status: EditSettingsStatus.failed,
      )),
    );
  }

  Future<void> _onSettingsComplete(
    final EditSettingsComplete event,
    final Emitter<EditSettingsState> emit,
  ) async {
    emit(const EditSettingsState());
  }
}
