import 'dart:async';
import 'dart:developer';

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
    required final String dialogId,
  });

  Future<Either<void, Failure>> createDialog({
    required final UserEntity user,
    required final String dialogWith,
  });

  Future<Either<void, Failure>> deleteDialog({
    required final String dialogId,
  });

  Future<Either<void, Failure>> sendMessage({
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
      final dialogsQuery = FirebaseFirestore.instance
          .collection('/dialogs')
          .where('participants', arrayContains: userId);

      final docs = await dialogsQuery.get();

      return Left(
        (await Future.wait(docs.docs.map((e) async {
          final dialogWith = await FirebaseFirestore.instance
              .collection('/users')
              .doc(e.data()['participants'].firstWhere((e) => e != userId))
              .get();

          return DialogModel.fromJson(
              json: e.data()
                ..addAll({
                  'id': e.id,
                  'dialogWith': UserModel.fromJson(json: dialogWith.data()!)
                }));
        })))
            .toList(),
      );
    } on FirebaseException catch (e) {
      log('Firestore exception: ${e.code}',
          name: 'FirebaseRepository', error: e);
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      log('Firestore exception: $e', name: 'FirebaseRepository', error: e);
      return Right(UndefinedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<List<MessageEntity>, Failure>> getMessagesList({
    required final String dialogId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Right(ConnectionFailure(message: 'No internet connection!'));
    }

    try {
      final messagesQuery = FirebaseFirestore.instance
          .collection('/dialogs')
          .doc(dialogId)
          .collection('/messages')
          .orderBy('createdTimestamp', descending: true);

      return Left((await messagesQuery.get())
          .docs
          .map((e) => MessageModel.fromJson(json: e.data()))
          .toList());
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> deleteDialog({
    required final String dialogId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Right(ConnectionFailure(message: 'No internet connection!'));
    }

    try {
      await FirebaseFirestore.instance
          .collection('dialogs')
          .doc(dialogId)
          .delete();

      return const Left(null);
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
          .doc(user.id)
          .get();

      await FirebaseFirestore.instance.collection('dialogs').add({
        'participants': [user.id, dialogWith],
        'lastMessage': MessageModel.empty(
          senderId: user.id,
          senderInitials: sender.data()!['id'],
          to: dialogWith,
        ).toJson(),
        'updatedTimestamp': FieldValue.serverTimestamp(),
      });

      return const Left(null);
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> sendMessage({
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

      final DocumentReference dialogRef =
          FirebaseFirestore.instance.collection('/dialogs').doc(dialog.id);

      await dialogRef.update({'lastMessage': message.toJson()});

      await dialogRef.collection('/messages').add(message.toJson());

      return const Left(null);
    } on FirebaseException catch (e) {
      return Right(RequestFailure(message: 'Firestore exception: ${e.code}'));
    } catch (e) {
      return Right(UndefinedFailure(message: e.toString()));
    }
  }
}
