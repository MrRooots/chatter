import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

final class CreateDialogParams {
  final UserEntity user;
  final String dialogWith;

  const CreateDialogParams({required this.user, required this.dialogWith});
}

final class CreateDialogUseCase extends UseCase<void, CreateDialogParams> {
  final FirebaseRepository repository;

  CreateDialogUseCase({required this.repository});

  @override
  Future<Either<void, Failure>> call(
    final CreateDialogParams params,
  ) async {
    return await repository.createDialog(
      user: params.user,
      dialogWith: params.dialogWith,
    );
  }
}
