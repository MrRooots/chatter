import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:chatter/features/presentation/common/widgets/default_button.dart';
import 'package:chatter/features/presentation/common/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPageBody extends StatefulWidget {
  const SignUpPageBody({super.key});

  @override
  State<SignUpPageBody> createState() => _SignUpPageBodyState();
}

class _SignUpPageBodyState extends State<SignUpPageBody> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();

  bool isPasswordHide = true;

  String get username => _usernameController.text.trim();

  String get password => _passwordController.text.trim();

  String get firstname => _usernameController.text.trim();

  String get lastname => _usernameController.text.trim();

  String get email => _emailController.text.trim();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();

    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _firstnameFocusNode.dispose();
    _emailFocusNode.dispose();

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
                      'Start with your',
                      style: TextStyle(fontSize: 32.0),
                    ),
                    Text(
                      'Sign Up',
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
              _buildFormInputField(
                _firstnameController,
                _firstnameFocusNode,
                'First name',
                'Enter your first name',
              ),
              const SizedBox(height: 16.0),
              _buildFormInputField(
                _lastnameController,
                _lastnameFocusNode,
                'Last name',
                'Enter your last name',
              ),
              const SizedBox(height: 16.0),
              _buildFormInputField(
                _usernameController,
                _usernameFocusNode,
                'Username',
                'Enter username',
              ),
              const SizedBox(height: 16.0),
              _buildFormInputField(
                _emailController,
                _emailFocusNode,
                'Email',
                'Enter email',
                type: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              _buildPasswordInput(),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    state.isFailed ? state.message : '',
                    style: const TextStyle(color: Palette.red),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      DefaultButton(
                        onPressed: () =>
                            BlocProvider.of<SignUpBloc>(context).add(
                          SignUpStart(
                            username: username,
                            password: password,
                            firstname: firstname,
                            lastname: lastname,
                            email: email,
                          ),
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
                                    : 'Sign Up',
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        mainText: 'Already have an account?',
                        accentText: 'Sign In!',
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

  TextFormField _buildFormInputField(
    final TextEditingController controller,
    final FocusNode focusNode,
    final String label,
    final String hint, {
    final TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () =>
          BlocProvider.of<SignUpBloc>(context).add(const SignUpClean()),
      style: const TextStyle(decoration: TextDecoration.none),
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      obscureText: isPasswordHide,
      autocorrect: false,
      style: const TextStyle(decoration: TextDecoration.none),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () =>
          BlocProvider.of<SignUpBloc>(context).add(const SignUpClean()),
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
