import 'package:chatter/features/domain/common/entities/user_settings_entity.dart';

final class UserSettingsModel extends UserSettingsEntity {
  const UserSettingsModel({
    required super.darkTheme,
    required super.showOnboarding,
    required super.receiveNotifications,
  });

  bool get isDarkThemeEnabled => darkTheme;

  bool get isShowOnboardingEnabled => showOnboarding;

  bool get isNotificationsEnabled => receiveNotifications;

  /// Default [UserSettingsModel] constructor
  factory UserSettingsModel.empty() {
    return const UserSettingsModel(
      darkTheme: false,
      showOnboarding: false,
      receiveNotifications: false,
    );
  }

  /// Construct configuration model from [json]
  factory UserSettingsModel.fromJson({
    required final Map<String, dynamic> json,
  }) {
    return UserSettingsModel(
      darkTheme: json['darkTheme'],
      showOnboarding: json['showOnboarding'],
      receiveNotifications: json['receiveNotifications'],
    );
  }

  /// Convert current model to json
  Map<String, dynamic> toJson() {
    return {
      'darkTheme': darkTheme,
      'showOnboarding': showOnboarding,
      'receiveNotifications': receiveNotifications,
    };
  }
}
