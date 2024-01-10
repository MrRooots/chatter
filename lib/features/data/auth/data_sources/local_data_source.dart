import 'package:chatter/core/constants/constants.dart';
import 'package:chatter/core/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  /// Get the first launch marker from local storage
  /// Returns [bool]
  ///
  /// Throws [CacheException]
  bool get isFirstLaunch;

  /// Set the first launch param for current application
  ///
  /// Returns [bool]
  ///
  /// Throws [CacheException]
  Future<bool> changeFirstLaunchValue({final bool value = false});
}

final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  bool get isFirstLaunch {
    try {
      return sharedPreferences.getBool(Constants.isFirstLaunchKey) ?? true;
    } on Exception {
      throw const CacheException(message: 'Failed to get launch param');
    }
  }

  @override
  Future<bool> changeFirstLaunchValue({final bool value = false}) async {
    try {
      return await sharedPreferences.setBool(Constants.isFirstLaunchKey, value);
    } on Exception {
      throw const CacheException(message: 'Failed to update launch param');
    }
  }
}
