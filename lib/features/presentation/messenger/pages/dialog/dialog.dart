import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialog_bloc/dialog_bloc.dart';
import 'package:chatter/features/presentation/messenger/pages/dialog/components/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
              BlocBuilder<DialogBloc, DialogState>(
                builder: (context, state) {
                  if (state.isSuccess) {
                    if (state.messages!.isEmpty) {
                      return const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/error.png'),
                              height: 128,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'You dont have any messages yet!\nType something!',
                              style: TextStyle(color: Palette.black),
                            ),
                          ],
                        ),
                      );
                    }
                    final String userId =
                        BlocProvider.of<AuthenticationBloc>(context)
                            .currentUser
                            .id;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.messages!.length,
                        itemBuilder: (context, index) {
                          return MessageCard(
                            message: state.messages![index],
                            isLeft: state.messages![index].senderId == userId,
                          );
                        },
                      ),
                    );
                  } else if (state.isFailed) {
                    return Expanded(
                      child: Center(
                        child: Text(state.message),
                      ),
                    );
                  } else {
                    return const Expanded(
                      child: Center(
                        child: SpinKitSpinningLines(
                          color: Palette.lightGreenSalad,
                        ),
                      ),
                    );
                  }
                },
              ),
              _getMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _getMessageInput() {
    return TextFormField(
      controller: _messageController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      style: const TextStyle(decoration: TextDecoration.none),
      decoration: InputDecoration(
        hintText: 'Message...',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 64.0,
          maxWidth: 64.0,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            if (_messageController.text.trim().isEmpty) return;

            BlocProvider.of<DialogBloc>(context).add(DialogSendMessage(
              dialog: widget.dialog,
              currentUser:
                  BlocProvider.of<AuthenticationBloc>(context).currentUser,
              message: _messageController.text,
            ));
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
    );
  }
}
