import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

final class MarkDialogReadParams {
  final String dialogId;

  const MarkDialogReadParams({required this.dialogId});
}

final class MarkDialogReadUsecase extends UseCase<void, MarkDialogReadParams> {
  final FirebaseRepository repository;

  MarkDialogReadUsecase({required this.repository});

  @override
  Future<Either<void, Failure>> call(final MarkDialogReadParams params) async {
    return await repository.markDialogAsRead(dialogId: params.dialogId);
  }
}
