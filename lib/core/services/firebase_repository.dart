import 'package:chatter/core/exceptions/failures.dart';
import 'package:chatter/core/services/network_info.dart';
import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/messenger/models/dialog_model.dart';
import 'package:chatter/features/data/messenger/models/message_model.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract interface class FirebaseRepository {
  Future<Either<List<DialogEntity>, Failure>> getDialogsList({
    required final String userId,
  });

  Future<Either<List<MessageEntity>, Failure>> getMessagesList({
    required final String userId,
    required final String dialogId,
  });

  Future<Either<void, Failure>> createDialog({
    required final UserEntity user,
    required final String dialogWith,
  });

  Future<Either<List<MessageEntity>, Failure>> sendMessage({
    required final String messageBody,
    required final DialogEntity dialog,
    required final UserEntity currentUser,
    required final String receiptId,
  });
}

final class FirebaseRepositoryImpl implements FirebaseRepository {
  final NetworkInfo networkInfo;

  const FirebaseRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<List<DialogEntity>, Failure>> getDialogsList({
    required final String userId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Right(ConnectionFailure(message: 'No internet connection!'));
    }

    try {
      final docs = await FirebaseFirestore.instance
          .collection('/users')
          .doc(userId)
          .collection('/dialogs')
          .get();

      return Left(
        docs.docs
            .map(
              (e) => DialogModel(
                id: e.id,
                sender:
                    UserModel.fromJson(json: e.data()['sender']) as UserEntity,
                messages: const [],
              ),
            )
            .toList(),
      );
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<List<MessageEntity>, Failure>> getMessagesList({
    required final String userId,
    required final String dialogId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Right(ConnectionFailure(message: 'No internet connection!'));
    }

    try {
      final docs = await FirebaseFirestore.instance
          .collection('/users')
          .doc(userId)
          .collection('/dialogs')
          .doc(dialogId)
          .collection('/messages')
          .orderBy('createdTimestamp', descending: false)
          .get();

      return Left(
        docs.docs.map((e) => MessageModel.fromJson(json: e.data())).toList(),
      );
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> createDialog({
    required UserEntity user,
    required String dialogWith,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Right(ConnectionFailure(message: 'No internet connection!'));
    }

    try {
      final sender = await FirebaseFirestore.instance
          .collection('/users')
          .doc(dialogWith)
          .get();

      final Map<String, dynamic> dialogData = {
        'sender': sender.data(),
      };

      // Our dialogs
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(user.id)
          .collection('/dialogs')
          .doc(dialogWith)
          .set(dialogData);

      // Receipt dialogs
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(dialogWith)
          .collection('/dialogs')
          .doc(user.id)
          .set({'sender': (user as UserModel).toJson()});

      return const Left(null);
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<List<MessageEntity>, Failure>> sendMessage({
    required final String messageBody,
    required final DialogEntity dialog,
    required final UserEntity currentUser,
    required final String receiptId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Right(ConnectionFailure(message: 'No internet connection!'));
    }

    try {
      final MessageModel message = MessageModel(
        senderId: currentUser.id,
        senderInitials: currentUser.username,
        to: receiptId,
        body: messageBody,
        createdTimestamp: DateTime.now().millisecondsSinceEpoch,
        isViewed: false,
      );

      await FirebaseFirestore.instance
          .collection('/users')
          .doc(currentUser.id)
          .collection('/dialogs')
          .doc(dialog.id)
          .collection('/messages')
          .add(message.toJson());

      await FirebaseFirestore.instance
          .collection('/users')
          .doc(receiptId)
          .collection('/dialogs')
          .doc(dialog.id)
          .collection('/messages')
          .add(message.toJson());

      final docs = await FirebaseFirestore.instance
          .collection('/users')
          .doc(message.senderId)
          .collection('/dialogs')
          .doc(dialog.id)
          .collection('/messages')
          .orderBy('createdTimestamp', descending: false)
          .get();

      return Left(
        docs.docs.map((e) => MessageModel.fromJson(json: e.data())).toList(),
      );
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }
}
