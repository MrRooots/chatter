import 'package:chatter/core/exceptions/exceptions.dart';
import 'package:chatter/core/services/network_info.dart';
import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/common/models/user_settings_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class ProfileRemoteDataSource {
  /// Update user [settings] in database
  ///
  /// Returns updated [UserModel]
  ///
  /// Throw [AuthorizationException], [ConnectionException]
  Future<UserModel> updateProfileSettings({
    required final UserModel user,
  });

  /// Update [user] information in database
  ///
  /// Returns updated [UserModel]
  ///
  /// Throw [AuthorizationException], [ConnectionException]
  Future<UserModel> updateUser({required final UserModel user});

  /// Update [user] password to [newPassword]
  ///
  /// Returns updated [UserModel]
  ///
  /// Throw [AuthorizationException], [ConnectionException]
  Future<UserModel> updateUserPassword({
    required final UserModel user,
    required final String oldPassword,
    required final String newPassword,
  });

  Stream<UserModel?> profileUpdatesStream({required final UserModel user});
}

final class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final NetworkInfo networkInfo;

  const ProfileRemoteDataSourceImpl({required this.networkInfo});

  @override
  Future<UserModel> updateProfileSettings({
    required final UserModel user,
  }) async {
    if (await networkInfo.isConnected) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'settings': (user.settings as UserSettingsModel).toJson()});

      return user;
    } else {
      throw const ConnectionException(message: 'No internet connection!');
    }
  }

  @override
  Future<UserModel> updateUser({required final UserModel user}) async {
    if (await networkInfo.isConnected) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toJson());

      return user;
    } else {
      throw const ConnectionException(message: 'No internet connection!');
    }
  }

  @override
  Future<UserModel> updateUserPassword({
    required final UserModel user,
    required final String oldPassword,
    required final String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        try {
          await currentUser.reauthenticateWithCredential(
              EmailAuthProvider.credential(
                  email: user.email, password: oldPassword));
          await currentUser.updatePassword(newPassword);
        } on FirebaseAuthException catch (e) {
          throw AuthorizationException(
            message: e.message ?? 'Failed to update password!',
          );
        }
      } else {
        throw const AuthorizationException(
            message: 'Current user not defined!');
      }

      return user;
    } else {
      throw const ConnectionException(message: 'No internet connection!');
    }
  }

  Stream<UserModel?> profileUpdatesStream({required final UserModel user}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .snapshots()
        .map((final DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          final Map<String, dynamic> json =
              documentSnapshot.data()! as Map<String, dynamic>;

          return UserModel.fromJson(json: json);
        } on Exception {
          // pass
        }
      }

      return null;
    });
  }
}
