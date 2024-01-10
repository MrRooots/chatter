import 'package:chatter/features/presentation/auth/pages/sign_in/components/body.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const String routeName = '/login';

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0.0),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(hasScrollBody: false, child: SignInPageBody())
          ],
        ),
      ),
    );
  }
}
