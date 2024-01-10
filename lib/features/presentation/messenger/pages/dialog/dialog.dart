import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/presentation/messenger/pages/dialog/components/message_card.dart';
import 'package:flutter/material.dart';

class DialogPage extends StatefulWidget {
  static const String routeName = '/dialog';

  final DialogEntity dialog;

  const DialogPage({super.key, required this.dialog});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (final DragUpdateDetails details) {
          if (details.delta.dx > 6) Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.dialog.messages.length,
                  itemBuilder: (context, index) => MessageCard(
                    message: widget.dialog.messages[index],
                    isLeft: index % 2 == 0,
                  ),
                ),
              ),
              TextFormField(
                controller: _messageController,
                // focusNode: _focusNodePassword,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autocorrect: true,
                style: const TextStyle(decoration: TextDecoration.none),
                // onTapOutside: (_) =>
                //     FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIconConstraints: const BoxConstraints(
                    maxHeight: 64.0,
                    maxWidth: 64.0,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // send message
                      _messageController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Palette.lightGreenSalad,
                      size: 24.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
