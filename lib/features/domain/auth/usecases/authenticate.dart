import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/auth/repositories/auth_repository.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

final class AuthenticateUserUsecase implements UseCaseWithoutParams {
  final AuthRepository repository;

  const AuthenticateUserUsecase({required this.repository});

  @override
  Future<Either<UserEntity, Failure>> call() async =>
      await repository.authenticate();
}
