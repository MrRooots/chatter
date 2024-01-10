import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

final class UpdatePasswordParams {
  final UserEntity user;
  final String newPassword;
  final String oldPassword;

  const UpdatePasswordParams({
    required this.user,
    required this.oldPassword,
    required this.newPassword,
  });
}

final class UpdatePasswordUsecase
    implements UseCase<UserEntity, UpdatePasswordParams> {
  final ProfileRepository repository;

  const UpdatePasswordUsecase({required this.repository});

  @override
  Future<Either<UserEntity, Failure>> call(
    final UpdatePasswordParams params,
  ) async {
    return await repository.updatePassword(
      user: params.user,
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}
