import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

class DialogEntity extends Equatable {
  final String id;

  final List<MessageEntity> messages;

  const DialogEntity({required this.id, required this.messages});

  @override
  List<Object?> get props => [id, messages];
}
