import 'dart:developer';

import 'package:chatter/core/themes/theme.dart';
import 'package:chatter/features/domain/messenger/entities/dialog_entity.dart';
import 'package:chatter/features/presentation/about/pages/about/about_page.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:chatter/features/presentation/auth/pages/onboarding/onboarding.dart';
import 'package:chatter/features/presentation/auth/pages/sign_in/sign_in.dart';
import 'package:chatter/features/presentation/auth/pages/sign_up/sign_up.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/pages/splash.dart';
import 'package:chatter/features/presentation/common/pages/undefined_page.dart';
import 'package:chatter/features/presentation/messenger/pages/dialog/dialog.dart';
import 'package:chatter/features/presentation/messenger/pages/home/home.dart';
import 'package:chatter/features/presentation/messenger/pages/search_users/search_users.dart';
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
    return BlocProvider<AuthenticationBloc>.value(
      value: sl.get<AuthenticationBloc>(),
      child: MaterialApp(
        title: 'Chatter',
        theme: MyTheme.baseTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (final RouteSettings settings) {
          return MaterialPageRoute(builder: (context) {
            late Widget child;

            switch (settings.name) {
              case '/':
              case '/splash':
                return BlocProvider.value(
                  value: sl<AuthenticationBloc>()
                    ..add(const AuthenticationStart()),
                  child: const SplashPage(),
                );

              // /messenger
              case DialogPage.routeName:
                child = DialogPage(dialog: settings.arguments as DialogEntity);
              case HomePage.routeName:
                child = const HomePage();
              case SearchUsersPage.routeName:
                child = const SearchUsersPage();

              // /auth
              case OnboardingPage.routeName:
                child = const OnboardingPage();
              case SignInPage.routeName:
                child = BlocProvider<SignInBloc>(
                  create: (_) => sl<SignInBloc>(),
                  child: const SignInPage(),
                );
              case SignUpPage.routeName:
                child = BlocProvider<SignUpBloc>(
                  create: (context) => sl<SignUpBloc>(),
                  child: const SignUpPage(),
                );

              // /profile
              case ProfilePage.routeName:
                child = MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: sl<EditProfileBloc>()),
                    BlocProvider.value(value: sl<EditPasswordBloc>()),
                    BlocProvider.value(value: sl<EditSettingsBloc>()),
                  ],
                  child: const ProfilePage(),
                );
              case EditProfilePage.routeName:
                child = BlocProvider.value(
                  value: sl<EditProfileBloc>(),
                  child: const EditProfilePage(),
                );
              case EditPasswordPage.routeName:
                child = BlocProvider.value(
                  value: sl<EditPasswordBloc>(),
                  child: const EditPasswordPage(),
                );
              case EditSettingsPage.routeName:
                child = BlocProvider.value(
                  value: sl<EditSettingsBloc>(),
                  child: const EditSettingsPage(),
                );

              // /about
              case AboutPage.routeName:
                child = const AboutPage();

              default:
                child = UndefinedPage(route: settings.name ?? 'NULL');
            }

            log('Rebuilds for ${settings.name}', name: 'Application');

            return child;
          });
        },
      ),
    );
  }
}
