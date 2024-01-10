import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/auth/repositories/auth_repository.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

final class SignInUserParams {
  final String email;
  final String password;

  const SignInUserParams({required this.email, required this.password});
}

final class SignInUserUsecase implements UseCase<UserEntity, SignInUserParams> {
  final AuthRepository repository;

  const SignInUserUsecase({required this.repository});

  @override
  Future<Either<UserEntity, Failure>> call(
    final SignInUserParams params,
  ) async {
    return await repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
