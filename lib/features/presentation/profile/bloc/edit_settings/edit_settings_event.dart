part of 'edit_settings_bloc.dart';

abstract class EditSettingsEvent extends Equatable {
  const EditSettingsEvent();

  @override
  List<Object?> get props => [];
}

final class EditSettingsStart extends EditSettingsEvent {
  final UserEntity user;
  final bool darkTheme;
  final bool showOnboarding;
  final bool receiveNotifications;

  const EditSettingsStart({
    required this.user,
    required this.darkTheme,
    required this.showOnboarding,
    required this.receiveNotifications,
  });

  @override
  List<Object?> get props =>
      [user, darkTheme, showOnboarding, receiveNotifications];
}

final class EditSettingsComplete extends EditSettingsEvent {
  const EditSettingsComplete();
}
