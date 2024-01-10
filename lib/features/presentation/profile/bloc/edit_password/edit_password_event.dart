part of 'edit_password_bloc.dart';

abstract class EditPasswordEvent extends Equatable {
  const EditPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class EditPasswordStart extends EditPasswordEvent {
  final UserEntity user;
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;

  const EditPasswordStart({
    required this.user,
    required this.currentPassword,
    required this.newPassword,
    required this.repeatPassword,
  });

  /// Checks if current event params are valid
  bool get isValid {
    return currentPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        newPassword == repeatPassword;
  }

  @override
  List<Object?> get props =>
      [user, currentPassword, newPassword, repeatPassword];
}

final class EditPasswordComplete extends EditPasswordEvent {
  const EditPasswordComplete();
}
