import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/auth/pages/sign_in/sign_in.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialogs_list_bloc/dialogs_list_bloc.dart';
import 'package:chatter/features/presentation/messenger/pages/home/home.dart';
import 'package:chatter/features/presentation/onboarding/onboarding.dart';
import 'package:chatter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        final params = ModalRoute.of(context)!.settings.arguments;
        bool waitForUnauth =
            params == null ? false : (params as Map)['unauth'] ?? false;

        BlocProvider.of<AuthenticationBloc>(context)
            .subscribeToProfileChangeEvents();

        await Future.delayed(const Duration(milliseconds: 1000));

        if (!context.mounted) return;

        if (state.isAuthenticated && !waitForUnauth) {
          if (state.user!.settings.showOnboarding) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                OnboardingPage.routeName, (route) => false);
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          }
        } else if (state.isFirstLaunch) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              OnboardingPage.routeName, (route) => false);
        } else if (state.isUnauthenticated || state.isUndefined) {
          sl.resetLazySingleton<DialogsListBloc>();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(SignInPage.routeName, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.0),
        body: const SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/message.png')),
              SpinKitSpinningLines(color: Palette.lightGreenSalad),
              SizedBox(height: 16.0),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
