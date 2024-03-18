import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';

class DotsRow extends StatelessWidget {
  final int currentPage;

  const DotsRow({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: {
          0: Palette.lightGreen,
          1: Palette.lightBlue,
          2: Palette.orange,
        }
            .entries
            .map((final MapEntry<int, Color> entry) => Row(
                  children: [
                    Container(
                      height: 16.0,
                      width: 16.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == entry.key
                            ? entry.value
                            : Palette.grey.withOpacity(.4),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
