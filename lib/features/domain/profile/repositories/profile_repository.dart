import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ProfileRepository {
  /// Update whole user information with given one
  ///
  /// Returns updated [UserEntity] on success and [Failure] on errors
  Future<Either<UserEntity, Failure>> updateUser({
    required final UserEntity user,
  });

  /// Update [user] password to [newPassword]
  ///
  /// Returns updated [UserEntity] on success and [Failure] on errors
  Future<Either<UserEntity, Failure>> updatePassword({
    required final UserEntity user,
    required final String oldPassword,
    required final String newPassword,
  });

  /// Update user profile information
  ///
  /// Returns updated [UserEntity] on success and [Failure] on errors
  Future<Either<UserEntity, Failure>> updateProfileInformation({
    required final UserEntity user,
  });

  /// Update user password
  ///
  /// Returns updated [UserEntity] on success and [Failure] on errors
  Future<Either<UserEntity, Failure>> updateUserSettings({
    required final UserEntity user,
  });

  Either<Stream<UserEntity?>, Failure> profileUpdatesStream({
    required final UserEntity user,
  });
}
