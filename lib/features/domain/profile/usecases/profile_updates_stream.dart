import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

final class ProfileUpdatesListenParams {
  final UserEntity user;

  const ProfileUpdatesListenParams({required this.user});
}

final class ProfileUpdatesListenUsecase
    implements UseCase<Stream<UserEntity?>, ProfileUpdatesListenParams> {
  final ProfileRepository repository;

  const ProfileUpdatesListenUsecase({required this.repository});

  @override
  Future<Either<Stream<UserEntity?>, Failure>> call(
    final ProfileUpdatesListenParams params,
  ) async {
    return repository.profileUpdatesStream(user: params.user);
  }
}
