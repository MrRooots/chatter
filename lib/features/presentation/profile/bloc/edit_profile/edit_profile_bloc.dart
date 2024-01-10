import 'dart:async';

import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/usecases/update_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUsecase updateProfile;

  EditProfileBloc({required this.updateProfile})
      : super(const EditProfileState()) {
    on<EditProfileStart>(_onEditProfileStart);
    on<EditProfileComplete>(_onEditProfileComplete);
  }

  Future<void> _onEditProfileStart(
    final EditProfileStart event,
    final Emitter<EditProfileState> emit,
  ) async {
    emit(const EditProfileState(status: EditProfileStatus.loading));

    final UserEntity newUser = (event.user as UserModel).copyWith(
      firstname: event.firstname,
      lastname: event.lastname,
      status: event.status,
    );

    final failureOrUpdatedUser =
        await updateProfile(UpdateProfileParams(user: newUser));

    failureOrUpdatedUser.fold(
      (final user) => emit(state.copyWith(
        user: user,
        message: '',
        status: EditProfileStatus.success,
      )),
      (final failure) => emit(EditProfileState(
        message: failure.message,
        status: EditProfileStatus.failed,
      )),
    );
  }

  void _onEditProfileComplete(
    final EditProfileComplete event,
    final Emitter<EditProfileState> emit,
  ) {
    emit(const EditProfileState());
  }
}
