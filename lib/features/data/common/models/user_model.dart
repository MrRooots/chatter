import 'package:chatter/features/data/common/models/user_settings_model.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.username,
    required super.status,
    required super.settings,
  });

  factory UserModel.fromJson({required final Map<String, dynamic> json}) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      username: json['username'],
      status: json['status'],
      settings: UserSettingsModel.fromJson(json: json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'username': username,
      'status': status,
      'settings': (settings as UserSettingsModel).toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? username,
    String? status,
    UserSettingsModel? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      username: username ?? this.username,
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() {
    return '[UserModel]:\nid: $id\nfirstname: $firstname\nemail: $email\nusername: $username, settings: $settings';
  }
}
