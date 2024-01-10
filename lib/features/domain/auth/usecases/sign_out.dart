import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/auth/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

final class SignOutUserUsecase implements UseCaseWithoutParams {
  final AuthRepository repository;

  const SignOutUserUsecase({required this.repository});

  @override
  Future<Either<void, Failure>> call() async => await repository.signOut();
}
