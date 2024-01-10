import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

final class UpdateProfileParams {
  final UserEntity user;

  const UpdateProfileParams({required this.user});
}

final class UpdateProfileUsecase
    implements UseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository repository;

  const UpdateProfileUsecase({required this.repository});

  @override
  Future<Either<UserEntity, Failure>> call(
    final UpdateProfileParams params,
  ) async {
    return await repository.updateUser(user: params.user);
  }
}
