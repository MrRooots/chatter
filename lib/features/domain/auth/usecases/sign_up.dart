import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/auth/repositories/auth_repository.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

final class SignUpUserParams {
  final String email;
  final String username;
  final String password;
  final String firstname;
  final String lastname;

  const SignUpUserParams({
    required this.email,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
  });
}

final class SignUpUserUsecase implements UseCase<UserEntity, SignUpUserParams> {
  final AuthRepository repository;

  const SignUpUserUsecase({required this.repository});

  @override
  Future<Either<UserEntity, Failure>> call(
    final SignUpUserParams params,
  ) async {
    return await repository.signUp(
      email: params.email,
      username: params.username,
      password: params.password,
      firstname: params.firstname,
      lastname: params.lastname,
    );
  }
}
