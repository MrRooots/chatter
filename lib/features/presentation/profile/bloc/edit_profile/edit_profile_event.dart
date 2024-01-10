part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

final class EditProfileStart extends EditProfileEvent {
  final UserEntity user;
  final String firstname;
  final String lastname;
  final String status;

  const EditProfileStart({
    required this.user,
    required this.firstname,
    required this.lastname,
    required this.status,
  });

  /// Checks if current event is valid
  bool get isValid => firstname.isNotEmpty && lastname.isNotEmpty;

  @override
  List<Object?> get props => [user, firstname, lastname, status];
}

final class EditProfileComplete extends EditProfileEvent {
  const EditProfileComplete();
}
