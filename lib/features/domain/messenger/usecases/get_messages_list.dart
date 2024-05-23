import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

final class GetMessagesListParams {
  final String dialogId;

  const GetMessagesListParams({required this.dialogId});
}

final class GetMessagesListUsecase
    extends UseCase<List<MessageEntity>, GetMessagesListParams> {
  final FirebaseRepository repository;

  GetMessagesListUsecase({required this.repository});

  @override
  Future<Either<List<MessageEntity>, Failure>> call(
    final GetMessagesListParams params,
  ) async {
    return await repository.getMessagesList(
      dialogId: params.dialogId,
    );
  }
}
