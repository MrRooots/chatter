import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class OnboardingPageItemFirst extends StatelessWidget {
  static const pageColor = Palette.lightGreen;

  const OnboardingPageItemFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(),
          Expanded(
              flex: 2,
              child: Image.asset('assets/images/message.png', scale: .8)),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'CHAT APP',
                  style: TextStyle(
                    color: pageColor,
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Simple messenger app made with\n',
                      ),
                      TextSpan(
                        text: 'Flutter',
                        style: TextStyle(
                          color: pageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' using '),
                      TextSpan(
                        text: 'Firebase',
                        style: TextStyle(
                          color: pageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: '\n\nIcons: '),
                      TextSpan(
                        text: 'icons8.com',
                        style: TextStyle(
                          color: pageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Palette.black,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
