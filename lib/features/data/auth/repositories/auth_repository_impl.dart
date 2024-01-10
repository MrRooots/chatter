import 'package:chatter/core/exceptions/exceptions.dart';
import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/features/data/auth/data_sources/local_data_source.dart';
import 'package:chatter/features/data/auth/data_sources/remote_data_source.dart';
import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/domain/auth/repositories/auth_repository.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

final class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<UserEntity, Failure>> authenticate() async {
    try {
      return Left(await remoteDataSource.authenticate());
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(
        message: e.message,
        isFirstLaunch: localDataSource.isFirstLaunch,
      ));
    } on ConnectionException {
      return const Right(ConnectionFailure(message: ''));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> signIn({
    required final String email,
    required final String password,
  }) async {
    try {
      await remoteDataSource.signIn(email: email, password: password);
      final UserModel user = await remoteDataSource.authenticate();
      await localDataSource.changeFirstLaunchValue(value: false);

      return Left(user);
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(
        message: e.message,
        isFirstLaunch: localDataSource.isFirstLaunch,
      ));
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> signUp({
    required final String email,
    required final String password,
    required final String firstname,
    required final String lastname,
    required final String username,
  }) async {
    try {
      await remoteDataSource.signUp(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
        username: username,
      );

      final UserModel user = await remoteDataSource.authenticate();

      await localDataSource.changeFirstLaunchValue(value: false);

      return Left(user);
    } on AuthorizationException catch (e) {
      return Right(AuthorizationFailure(
        message: e.message,
        isFirstLaunch: localDataSource.isFirstLaunch,
      ));
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }

  @override
  Future<Either<void, Failure>> signOut() async {
    try {
      return Left(await remoteDataSource.signOut());
    } on ConnectionException catch (e) {
      return Right(ConnectionFailure(message: e.message));
    }
  }
}
