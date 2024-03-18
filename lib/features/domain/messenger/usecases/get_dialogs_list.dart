import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:dartz/dartz.dart';

final class GetDialogsListParams {
  final String uid;

  const GetDialogsListParams({required this.uid});
}

final class GetDialogsListUsecase
    extends UseCase<List<DialogEntity>, GetDialogsListParams> {
  final FirebaseRepository repository;

  GetDialogsListUsecase({required this.repository});

  @override
  Future<Either<List<DialogEntity>, Failure>> call(
    final GetDialogsListParams params,
  ) async {
    return await repository.getDialogsList(userId: params.uid);
  }
}
