import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/usecases/usecase.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

final class SendMessageParams {
  final DialogEntity dialog;
  final String message;
  final UserEntity currentUser;
  final String receiptId;

  const SendMessageParams({
    required this.dialog,
    required this.message,
    required this.currentUser,
    required this.receiptId,
  });
}

final class SendMessageUsecase
    extends UseCase<List<MessageEntity>, SendMessageParams> {
  final FirebaseRepository repository;

  SendMessageUsecase({required this.repository});

  @override
  Future<Either<List<MessageEntity>, Failure>> call(
      final SendMessageParams params) async {
    return await repository.sendMessage(
      dialog: params.dialog,
      messageBody: params.message,
      currentUser: params.currentUser,
      receiptId: params.receiptId,
    );
  }
}
