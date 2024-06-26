import 'package:chatter/features/domain/messenger/entities/message_entity.dart';

final class MessageModel extends MessageEntity {
  const MessageModel({
    required super.senderId,
    required super.senderInitials,
    required super.to,
    required super.body,
    required super.createdTimestamp,
    required super.isViewed,
  });

  factory MessageModel.fromJson({required final Map<String, dynamic> json}) {
    return MessageModel(
      to: json['to'],
      senderId: json['senderId'],
      senderInitials: json['senderInitials'],
      body: json['body'],
      createdTimestamp: json['createdTimestamp'],
      isViewed: json['isViewed'],
    );
  }

  factory MessageModel.empty({
    final String? senderId,
    final String? to,
    final String? senderInitials,
    final String? body,
  }) {
    return MessageModel(
      senderId: senderId ?? '',
      senderInitials: senderInitials ?? '',
      to: to ?? '',
      body: body ?? '',
      createdTimestamp: DateTime.now().millisecondsSinceEpoch,
      isViewed: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'senderId': senderId,
      'senderInitials': senderInitials,
      'body': body,
      'createdTimestamp': createdTimestamp,
      'isViewed': isViewed,
    };
  }
}
