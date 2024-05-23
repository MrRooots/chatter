import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

final class DeleteDialogParams {
  final String dialogId;

  const DeleteDialogParams({required this.dialogId});
}

final class DeleteDialogUseCase extends UseCase<void, DeleteDialogParams> {
  final FirebaseRepository repository;

  DeleteDialogUseCase({required this.repository});

  @override
  Future<Either<void, Failure>> call(final DeleteDialogParams params) async {
    return await repository.deleteDialog(dialogId: params.dialogId);
  }
}
