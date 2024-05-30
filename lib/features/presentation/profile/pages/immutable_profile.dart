import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:flutter/material.dart';

class ImmutableProfilePage extends StatelessWidget {
  static String routeName = 'immutableProfile';

  final UserEntity user;

  const ImmutableProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (final DragUpdateDetails details) {
        if (details.delta.dx > 6) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 128.0,
                      width: 128.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(
                              color: Palette.lightGreenSalad, width: 2.0),
                        ),
                      ),
                      child: Image.asset('assets/images/user.png'),
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      '${user.firstname} ${user.lastname}',
                      style: const TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${user.username}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.lightGreenSalad,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '-- ${user.status} --',
                      style:
                          const TextStyle(fontSize: 16.0, color: Palette.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
