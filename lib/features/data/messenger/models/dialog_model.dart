import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/messenger/models/message_model.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';

final class DialogModel extends DialogEntity {
  const DialogModel({
    required super.id,
    required super.sender,
    required super.messages,
  });

  get messageModels => messages.map((e) => e as MessageModel).toList();

  factory DialogModel.fromJson({required final Map<String, dynamic> json}) {
    return DialogModel(
      id: json['id'],
      sender: UserModel.fromJson(json: json['sender']),
      messages: (json['messages'] as List)
          .map((final json) => MessageModel.fromJson(json: json))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': (sender as UserModel).toJson(),
      'messages': messages.map((e) => (e as MessageModel).toJson()).toList(),
    };
  }
}
