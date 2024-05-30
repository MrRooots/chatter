import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  /// Receiver id
  final String to;

  /// Sender id
  final String senderId;

  /// Sender first and last name
  final String senderInitials;

  /// Message body
  final String body;

  /// Timestamp when the message was created
  final int createdTimestamp;

  /// is message viewed by receipt
  final bool isViewed;

  const MessageEntity({
    required this.to,
    required this.senderId,
    required this.senderInitials,
    required this.body,
    required this.createdTimestamp,
    required this.isViewed,
  });

  @override
  List<Object?> get props =>
      [to, senderId, senderInitials, body, createdTimestamp, isViewed];
}
