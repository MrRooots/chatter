import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

class DialogEntity extends Equatable {
  final String id;

  final UserEntity sender;

  final List<MessageEntity> messages;

  const DialogEntity({
    required this.id,
    required this.sender,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, sender, messages];
}
