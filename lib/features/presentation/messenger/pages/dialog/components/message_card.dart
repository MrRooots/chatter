import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/messenger/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity message;
  final bool isLeft;

  const MessageCard({super.key, required this.message, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = DateTime.now();

    return GestureDetector(
      onLongPress: () => print('Edit message'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLeft) const SizedBox(width: 64.0),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: isLeft ? Palette.lightGreenSalad : Palette.purple,
                    width: .5,
                  ),
                ),
                color: (isLeft ? Palette.lightGreenSalad : Palette.purple)
                    .withOpacity(.1),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message.body, style: const TextStyle(fontSize: 16.0)),
                    Row(
                      children: [
                        const Expanded(child: SizedBox.shrink()),
                        Text(
                          DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  message.createdTimestamp)),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Palette.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isLeft) const SizedBox(width: 64.0),
        ],
      ),
    );
  }
}
