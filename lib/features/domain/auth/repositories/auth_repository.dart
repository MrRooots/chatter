import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRepository {
  Future<Either<UserEntity, Failure>> authenticate();

  /// Login with provided credentials
  Future<Either<UserEntity, Failure>> signIn({
    required final String email,
    required final String password,
  });

  /// Create bew account
  Future<Either<UserEntity, Failure>> signUp({
    required final String email,
    required final String password,
    required final String firstname,
    required final String lastname,
    required final String username,
  });

  /// Logout current user
  Future<Either<void, Failure>> signOut();
}
