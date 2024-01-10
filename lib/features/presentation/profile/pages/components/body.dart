import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/about/pages/about/about_page.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/pages/splash.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_password/edit_password_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_settings/edit_settings_bloc.dart';
import 'package:chatter/features/presentation/profile/pages/components/header.dart';
import 'package:chatter/features/presentation/profile/widgets/wide_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const ProfileHeader(),
          MultiBlocListener(
            listeners: [
              BlocListener<EditProfileBloc, EditProfileState>(
                listenWhen: (previous, current) => current.isSuccess,
                listener: (_, state) async {
                  await Future.delayed(const Duration(milliseconds: 750));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Palette.lightGreenSalad,
                      behavior: SnackBarBehavior.floating,
                      content: Text('Profile information updated!',
                          textAlign: TextAlign.center)));
                },
              ),
              BlocListener<EditPasswordBloc, EditPasswordState>(
                listenWhen: (previous, current) => current.isSuccess,
                listener: (_, state) async {
                  await Future.delayed(const Duration(milliseconds: 750));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: Palette.lightGreenSalad,
                    behavior: SnackBarBehavior.floating,
                    content: Text('Password updated!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Palette.white)),
                  ));
                },
              ),
              BlocListener<EditSettingsBloc, EditSettingsState>(
                listenWhen: (previous, current) => current.isSuccess,
                listener: (context, state) {
                  print('Updated settings');
                },
              ),
            ],
            child: const ProfileManagement(),
          ),
        ],
      ),
    );
  }
}

class ProfileManagement extends StatelessWidget {
  const ProfileManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(height: 32.0, color: Palette.lightGreenSalad),
        ),
        const Text(
          'Account settings',
          textAlign: TextAlign.left,
          style: TextStyle(color: Palette.grey),
        ),
        WideButton(
          onPressed: () => Navigator.of(context).pushNamed('/editProfile'),
          title: 'Edit profile information',
        ),
        WideButton(
          onPressed: () => Navigator.of(context).pushNamed('/editPassword'),
          title: 'Change password',
        ),
        WideButton(
          onPressed: () => Navigator.of(context).pushNamed('/editSettings'),
          title: 'Personal settings',
        ),
        WideButton(
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(const AuthenticationUnauth());
            Navigator.of(context).pushNamedAndRemoveUntil(
                SplashPage.routeName, (route) => false);
          },
          title: 'Log out',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(height: 32.0, color: Palette.lightGreenSalad),
        ),
        const Text(
          'More',
          style: TextStyle(color: Palette.grey),
        ),
        WideButton(
          onPressed: () => Navigator.of(context).pushNamed(AboutPage.routeName),
          title: 'About application',
        ),
      ],
    );
  }
}
