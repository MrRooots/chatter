import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class OnboardingPageItemSecond extends StatelessWidget {
  static const pageColor = Palette.lightBlue;

  const OnboardingPageItemSecond({super.key});

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
            child: Image.asset('assets/images/flutter.png', scale: .8),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  'FLUTTER',
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
                        text: 'Flutter is an open source',
                      ),
                      TextSpan(
                        text: ' framework by Google\n',
                        style: TextStyle(
                          color: pageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                          text:
                              'for building beautiful, natively compiled, multi-platform applications from a'),
                      TextSpan(
                        text: ' single codebase.',
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
