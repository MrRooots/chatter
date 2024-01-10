import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final ImageIcon? icon;

  const WideButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            backgroundColor: Palette.lightGrey,
            shadowColor: Colors.transparent,
            foregroundColor: Palette.lightGreenSalad,
            surfaceTintColor: Palette.lightGreenSalad,
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Palette.black)),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Palette.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
