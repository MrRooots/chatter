import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class NoDialogsPlaceholder extends StatelessWidget {
  const NoDialogsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/error.png'),
              height: 128,
            ),
            Text(
              textAlign: TextAlign.center,
              'You dont have any active dialogs right now!\nYou can start a new dialog using the button in right lower corner!',
              style: TextStyle(color: Palette.black),
            ),
          ],
        ),
      ],
    );
  }
}
