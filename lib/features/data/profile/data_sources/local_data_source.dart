import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/common/models/user_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ProfileLocalDataSource {
  /// Update user [settings] in local storage
  ///
  /// Returns updated [UserSettingsModel]
  ///
  /// Throw [AuthorizationException], [ConnectionException]
  Future<UserSettingsModel> updateProfileSettings({
    required final UserModel user,
  });
}

final class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  const ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserSettingsModel> updateProfileSettings({
    required final UserModel user,
  }) {
    // TODO: implement updateProfileSettings
    throw UnimplementedError();
  }
}
