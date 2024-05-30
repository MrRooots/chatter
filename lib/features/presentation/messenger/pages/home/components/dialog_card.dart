import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialogs_list_bloc/dialogs_list_bloc.dart';
import 'package:chatter/features/presentation/messenger/pages/dialog/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          '${dialog.dialogWith.firstname} ${dialog.dialogWith.lastname} (@${dialog.lastMessage.createdTimestamp})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Text(
          dialog.lastMessage.body.isNotEmpty ? dialog.lastMessage.body : '',
          maxLines: 2,
          style: const TextStyle(fontSize: 14.0),
        ),
        onLongPress: () => confirmDelete(context),
      ),
    );
  }

  Future<void> confirmDelete(final BuildContext context) async {
    final bool res = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Deletion',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text('Are you sure you want to delete this dialog?'),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Palette.lightGreenSalad, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete',
                        style:
                            TextStyle(color: Palette.lightRed, fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (res) {
      if (!context.mounted) return;

      BlocProvider.of<DialogsListBloc>(context).add(DialogsListDelete(
        user: BlocProvider.of<AuthenticationBloc>(context).currentUser,
        dialogId: dialog.id,
      ));
    }
  }
}
