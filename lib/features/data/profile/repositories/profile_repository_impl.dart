import 'package:chatter/core/exceptions/exceptions.dart';
import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/profile/data_sources/local_data_source.dart';
import 'package:chatter/features/data/profile/data_sources/remote_data_source.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Update whole [user] information with given one
  ///
  /// Returns updated [UserEntity] on success and [Failure] on errors
  @override
  Future<Either<UserEntity, Failure>> updateUser({
    required final UserEntity user,
  }) async {
    try {
      return Left(await remoteDataSource.updateUser(user: user as UserModel));
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(message: e.message));
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> updatePassword({
    required final UserEntity user,
    required final String oldPassword,
    required final String newPassword,
  }) async {
    try {
      final newUser = await remoteDataSource.updateUserPassword(
        user: user as UserModel,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      return await updateUser(user: newUser);
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(message: e.message));
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> updateProfileInformation(
      {required UserEntity user}) {
    // TODO: implement updateProfileInformation
    throw UnimplementedError();
  }

  @override
  Future<Either<UserEntity, Failure>> updateUserSettings({
    required UserEntity user,
  }) async {
    try {
      return Left(await remoteDataSource.updateProfileSettings(
        user: user as UserModel,
      ));
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(message: e.message));
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }

  @override
  Either<Stream<UserEntity?>, Failure> profileUpdatesStream({
    required UserEntity user,
  }) {
    try {
      return Left(remoteDataSource.profileUpdatesStream(
        user: user as UserModel,
      ));
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(message: e.message));
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }
}
