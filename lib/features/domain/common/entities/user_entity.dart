import 'package:chatter/features/domain/common/entities/user_settings_entity.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;

  final String firstname;

  final String lastname;

  final String email;

  final String username;

  final String status;

  final UserSettingsEntity settings;

  const UserEntity({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.status,
    required this.settings,
  });

  @override
  List<Object?> get props => [
        id,
        firstname,
        lastname,
        email,
        username,
        status,
        settings,
      ];
}
