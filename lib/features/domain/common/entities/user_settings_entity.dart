import 'package:equatable/equatable.dart';

class UserSettingsEntity extends Equatable {
  final bool darkTheme;
  final bool showOnboarding;
  final bool receiveNotifications;

  const UserSettingsEntity({
    required this.darkTheme,
    required this.showOnboarding,
    required this.receiveNotifications,
  });

  @override
  List<Object?> get props => [darkTheme, showOnboarding, receiveNotifications];
}
