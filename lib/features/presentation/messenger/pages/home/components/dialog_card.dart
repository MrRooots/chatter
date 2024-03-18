import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/presentation/messenger/pages/dialog/dialog.dart';
import 'package:flutter/material.dart';

class DialogCard extends StatelessWidget {
  final DialogEntity dialog;

  const DialogCard({super.key, required this.dialog});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, color: Palette.grey),
        ),
      ),
      child: ListTile(
        shape: const RoundedRectangleBorder(),
        onTap: () => Navigator.of(context)
            .pushNamed(DialogPage.routeName, arguments: dialog),
        title: Text(
          '@${dialog.sender.username}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Text(
          dialog.messages.isNotEmpty ? dialog.messages.last.body : '',
          maxLines: 2,
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
