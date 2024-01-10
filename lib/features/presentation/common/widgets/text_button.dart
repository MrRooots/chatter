import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class DefaultTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String mainText;
  final String accentText;

  const DefaultTextButton({
    super.key,
    required this.onPressed,
    required this.mainText,
    required this.accentText,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onPressed: onPressed,
      child: RichText(
        text: TextSpan(
          text: '$mainText ',
          style: const TextStyle(color: Palette.black),
          children: [
            TextSpan(
              text: accentText,
              style: const TextStyle(color: Palette.lightGreenSalad),
            ),
          ],
        ),
      ),
    );
  }
}
