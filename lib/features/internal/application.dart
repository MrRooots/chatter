import 'dart:developer';

import 'package:chatter/core/themes/theme.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/presentation/about/pages/about/about_page.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:chatter/features/presentation/auth/pages/sign_in/sign_in.dart';
import 'package:chatter/features/presentation/auth/pages/sign_up/sign_up.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/pages/splash.dart';
import 'package:chatter/features/presentation/common/pages/undefined_page.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialog_bloc/dialog_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialogs_list_bloc/dialogs_list_bloc.dart';
import 'package:chatter/features/presentation/messenger/pages/dialog/dialog.dart';
import 'package:chatter/features/presentation/messenger/pages/home/home.dart';
import 'package:chatter/features/presentation/messenger/pages/search_users/search_users.dart';
import 'package:chatter/features/presentation/onboarding/onboarding.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_password/edit_password_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_settings/edit_settings_bloc.dart';
import 'package:chatter/features/presentation/profile/pages/components/edit_password.dart';
import 'package:chatter/features/presentation/profile/pages/components/edit_profile.dart';
import 'package:chatter/features/presentation/profile/pages/components/edit_settings.dart';
import 'package:chatter/features/presentation/profile/pages/profile.dart';
import 'package:chatter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessengerApp extends StatelessWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('Main app build called', name: 'Application');

    return BlocProvider.value(
      value: sl.get<AuthenticationBloc>()..add(const AuthenticationStart()),
      child: MaterialApp(
        title: 'Chatter',
        theme: MyTheme.baseTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashPage.routeName,
        onGenerateRoute: (final RouteSettings settings) {
          log('onGenerateRoute called with ${settings.name}',
              name: 'Application');

          return MaterialPageRoute(builder: (context) {
            if (settings.name == SplashPage.routeName) {
              return const SplashPage();
            } else if (settings.name == DialogPage.routeName) {
              final DialogEntity dialog = settings.arguments as DialogEntity;
              final String userId =
                  BlocProvider.of<AuthenticationBloc>(context).currentUser.id;

              return BlocProvider(
                create: (context) => sl<DialogBloc>()
                  ..add(DialogOpen(
                    userId: userId,
                    dialogId: dialog.id,
                    sender: dialog.participants.firstWhere((e) => e != userId),
                  )),
                child: DialogPage(dialog: dialog),
              );
            } else if (settings.name == HomePage.routeName) {
              return BlocProvider(
                create: (context) => sl<DialogsListBloc>()
                  ..add(DialogsListFetch(
                    user: BlocProvider.of<AuthenticationBloc>(context)
                        .currentUser,
                  )),
                child: const HomePage(),
              );
            } else if (settings.name == SearchUsersPage.routeName) {
              return BlocProvider.value(
                value: sl<DialogsListBloc>(),
                child: const SearchUsersPage(),
              );
            } else if (settings.name == OnboardingPage.routeName) {
              return const OnboardingPage();
            } else if (settings.name == SignInPage.routeName) {
              return BlocProvider<SignInBloc>(
                create: (_) => sl<SignInBloc>(),
                child: const SignInPage(),
              );
            } else if (settings.name == SignUpPage.routeName) {
              return BlocProvider<SignUpBloc>(
                create: (context) => sl<SignUpBloc>(),
                child: const SignUpPage(),
              );
            } else if (settings.name == ProfilePage.routeName) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: sl<EditProfileBloc>()),
                  BlocProvider.value(value: sl<EditPasswordBloc>()),
                  BlocProvider(create: (_) => sl<EditSettingsBloc>()),
                ],
                child: const ProfilePage(),
              );
            } else if (settings.name == EditProfilePage.routeName) {
              return BlocProvider.value(
                value: sl<EditProfileBloc>(),
                child: const EditProfilePage(),
              );
            } else if (settings.name == EditPasswordPage.routeName) {
              return BlocProvider.value(
                value: sl<EditPasswordBloc>(),
                child: const EditPasswordPage(),
              );
            } else if (settings.name == EditSettingsPage.routeName) {
              return BlocProvider<EditSettingsBloc>(
                create: (_) => sl<EditSettingsBloc>(),
                child: const EditSettingsPage(),
              );
            } else if (settings.name == AboutPage.routeName) {
              return const AboutPage();
            } else {
              return UndefinedPage(route: settings.name ?? 'NULL');
            }
          });
        },
      ),
    );
  }
}
