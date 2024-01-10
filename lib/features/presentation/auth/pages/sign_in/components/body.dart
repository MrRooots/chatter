import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/widgets/default_button.dart';
import 'package:chatter/features/presentation/common/widgets/text_button.dart';
import 'package:chatter/features/presentation/messenger/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPageBody extends StatefulWidget {
  const SignInPageBody({super.key});

  @override
  State<SignInPageBody> createState() => _SignInPageBodyState();
}

class _SignInPageBodyState extends State<SignInPageBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  bool isPasswordHide = true;

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _focusNodePassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Spacer(),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proceed with your',
                      style: TextStyle(fontSize: 32.0),
                    ),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Palette.lightGreenSalad,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AutofillGroup(
                onDisposeAction: AutofillContextAction.commit,
                child: Column(
                  children: [
                    _buildEmailInput(),
                    const SizedBox(height: 16.0),
                    _buildPasswordInput(),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationAuth(user: state.user!));

              Future.delayed(const Duration(milliseconds: 1500)).then(
                (_) => Navigator.of(context).pushNamedAndRemoveUntil(
                    HomePage.routeName, (route) => false,
                    arguments: state.user),
              );
            }
          },
          builder: (context, state) {
            return Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    state.isFailed ? state.message : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Palette.red),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      DefaultButton(
                        onPressed: () =>
                            BlocProvider.of<SignInBloc>(context).add(
                          SignInStart(username: email, password: password),
                        ),
                        buttonColor: state.isFailed
                            ? Palette.lightRed
                            : Palette.lightGreenSalad,
                        width: state.isLoading ? 80.0 : 250.0,
                        text: state.isLoading
                            ? null
                            : state.isFailed
                                ? 'Failed'
                                : state.isSuccess
                                    ? 'Success'
                                    : 'Sign In',
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/register'),
                        mainText: 'Don\'t have an account?',
                        accentText: 'Create it now!',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }

  TextFormField _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () =>
          BlocProvider.of<SignInBloc>(context).add(const SignInClean()),
      style: const TextStyle(decoration: TextDecoration.none),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email, AutofillHints.username],
      onEditingComplete: () => print('Editing complete'),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter email...',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 32.0,
          maxWidth: 32.0,
        ),
        suffixIcon: Image.asset("assets/images/user.png", width: 32),
      ),
    );
  }

  TextFormField _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _focusNodePassword,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      obscureText: isPasswordHide,
      autocorrect: false,
      autofillHints: const [AutofillHints.password],
      style: const TextStyle(decoration: TextDecoration.none),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onEditingComplete: () => print('Editing complete'),
      onTap: () =>
          BlocProvider.of<SignInBloc>(context).add(const SignInClean()),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter password...',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 32.0,
          maxWidth: 32.0,
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => isPasswordHide = !isPasswordHide),
          child: isPasswordHide
              ? Image.asset("assets/images/password_hide.png", width: 32)
              : Image.asset("assets/images/password_show.png", width: 32),
        ),
      ),
    );
  }
}
