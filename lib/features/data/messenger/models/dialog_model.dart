import 'package:chatter/features/data/messenger/models/message_model.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';

final class DialogModel extends DialogEntity {
  const DialogModel({required super.id, required super.messages});

  get messageModels => messages.map((e) => e as MessageModel).toList();

  factory DialogModel.fromJson({required final Map<String, dynamic> json}) {
    return DialogModel(
      id: json['id'],
      messages: (json['messages'] as List)
          .map((final json) => MessageModel.fromJson(json: json))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((e) => (e as MessageModel).toJson()).toList(),
    };
  }
}
