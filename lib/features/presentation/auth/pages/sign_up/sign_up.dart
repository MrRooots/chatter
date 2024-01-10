import 'package:chatter/features/presentation/auth/pages/sign_up/components/body.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/register';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0.0),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: SignUpPageBody(),
            )
          ],
        ),
      ),
    );
  }
}
