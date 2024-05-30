import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

class DialogEntity extends Equatable {
  final String id;

  final UserEntity dialogWith;

  final MessageEntity lastMessage;

  final List<String> participants;

  final List<MessageEntity> messages;

  final int updatedTimestamp;

  const DialogEntity({
    required this.id,
    required this.dialogWith,
    required this.lastMessage,
    required this.participants,
    required this.messages,
    required this.updatedTimestamp,
  });

  @override
  List<Object?> get props => [
        id,
        dialogWith,
        lastMessage.createdTimestamp,
        participants,
        messages,
        updatedTimestamp,
      ];
}
