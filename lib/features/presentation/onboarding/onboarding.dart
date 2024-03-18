import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/auth/pages/sign_in/sign_in.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/pages/home/home.dart';
import 'package:chatter/features/presentation/onboarding/components/dots_row.dart';
import 'package:chatter/features/presentation/onboarding/components/first.dart';
import 'package:chatter/features/presentation/onboarding/components/second.dart';
import 'package:chatter/features/presentation/onboarding/components/third.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageViewController = PageController(initialPage: 0, keepPage: false);

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageViewController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: const [
                  OnboardingPageItemFirst(),
                  OnboardingPageItemSecond(),
                  OnboardingPageItemThird(),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            DotsRow(currentPage: _currentPage),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _currentPage == 2 ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          backgroundColor: Palette.orange,
          onPressed: () {
            try {
              BlocProvider.of<AuthenticationBloc>(context).currentUser;

              Navigator.of(context).pushNamedAndRemoveUntil(
                HomePage.routeName,
                (route) => false,
              );
            } catch (e) {
              Navigator.of(context).pushNamed(SignInPage.routeName);
            }
          },
          child: const Icon(Icons.navigate_next, color: Palette.white),
        ),
      ),
    );
  }
}
