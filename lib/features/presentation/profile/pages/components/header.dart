import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previous, current) => current.isAuthenticated,
      builder: (context, state) {
        final UserEntity user = state.user!;
        return Column(
          children: [
            Container(
              height: 128.0,
              width: 128.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Palette.lightGreenSalad, width: 2.0),
                ),
              ),
              child: Image.asset('assets/images/user.png'),
            ),
            const SizedBox(height: 32.0),
            Text(
              '${user.firstname} ${user.lastname}',
              style:
                  const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
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
              style: const TextStyle(fontSize: 16.0, color: Palette.grey),
            ),
          ],
        );
      },
    );
  }
}
