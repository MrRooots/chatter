import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class OnboardingPageItemThird extends StatelessWidget {
  static const pageColor = Palette.orange;
  const OnboardingPageItemThird({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Spacer(),
          Expanded(
            flex: 2,
            child: Image.asset('assets/images/firebase.png', scale: .8),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  'FIREBASE',
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
                        text: 'Firebase is an',
                      ),
                      TextSpan(
                        text: ' app development platform\n',
                        style: TextStyle(
                          color: pageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                          text:
                              'that helps you build and grow apps that users love.\n\nBacked by'),
                      TextSpan(
                        text: ' Google ',
                        style: TextStyle(
                          color: pageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                          text:
                              'and trusted by millions of businesses around the world.'),
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
