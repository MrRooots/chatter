import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class DialogLoadingFailedPlaceholder extends StatelessWidget {
  const DialogLoadingFailedPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(),
        const SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/error.png'), height: 128),
              Text(
                textAlign: TextAlign.center,
                'Failed to load dialogs!',
                style: TextStyle(color: Palette.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
