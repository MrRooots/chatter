import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/widgets/default_button.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_password/edit_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPasswordPage extends StatelessWidget {
  static const routeName = '/editPassword';

  const EditPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: 0.01,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: const CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: EditPasswordBody(),
            ),
          ),
        ],
      ),
    );
  }
}

class EditPasswordBody extends StatefulWidget {
  const EditPasswordBody({super.key});

  @override
  State<EditPasswordBody> createState() => _EditPasswordBodyState();
}

class _EditPasswordBodyState extends State<EditPasswordBody> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  final FocusNode _focusNodeNewPassword = FocusNode();
  final FocusNode _focusNodeRepeatPassword = FocusNode();
  final FocusNode _focusNodeCurrentPassword = FocusNode();

  bool isPasswordHide = true;

  String get newPassword => _newPasswordController.text.trim();

  String get repeatPassword => _repeatPasswordController.text.trim();

  String get currentPassword => _currentPasswordController.text.trim();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    _currentPasswordController.dispose();

    _focusNodeNewPassword.dispose();
    _focusNodeRepeatPassword.dispose();
    _focusNodeCurrentPassword.dispose();

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
                      'Change your profile',
                      style: TextStyle(fontSize: 32.0),
                    ),
                    Text(
                      'Password',
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
              _buildPasswordInput(
                controller: _currentPasswordController,
                focusNode: _focusNodeCurrentPassword,
                current: true,
              ),
              const SizedBox(height: 16.0),
              _buildPasswordInput(
                controller: _newPasswordController,
                focusNode: _focusNodeNewPassword,
              ),
              const SizedBox(height: 16.0),
              _buildPasswordInput(
                controller: _repeatPasswordController,
                focusNode: _focusNodeRepeatPassword,
                repeat: true,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        BlocConsumer<EditPasswordBloc, EditPasswordState>(
          listener: (context, state) {
            if (state.isSuccess && state.user != null) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationUpdated(newUser: state.user!));

              Future.delayed(const Duration(milliseconds: 500))
                  .then((_) => Navigator.of(context).pop());
            }
          },
          builder: (context, state) {
            return Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    state.isFailed ? state.message : '',
                    style: const TextStyle(color: Palette.red),
                  ),
                  const Spacer(),
                  DefaultButton(
                    onPressed: () =>
                        BlocProvider.of<EditPasswordBloc>(context).add(
                      EditPasswordStart(
                        user: BlocProvider.of<AuthenticationBloc>(context)
                            .currentUser,
                        currentPassword: currentPassword,
                        newPassword: newPassword,
                        repeatPassword: repeatPassword,
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
                                : 'Submit',
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  TextFormField _buildPasswordInput({
    required FocusNode focusNode,
    required TextEditingController controller,
    bool repeat = false,
    bool current = false,
  }) {
    final String label = current
        ? 'Current password'
        : repeat
            ? 'Repeat password'
            : 'New password';

    final String hint = current
        ? 'Current password...'
        : repeat
            ? 'Repeat password...'
            : 'Enter new password...';

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      obscureText: isPasswordHide,
      autocorrect: false,
      style: const TextStyle(decoration: TextDecoration.none),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 32.0,
          maxWidth: 32.0,
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => isPasswordHide = !isPasswordHide),
          child: isPasswordHide
              ? Image.asset("assets/images/password_hide.png")
              : Image.asset("assets/images/password_show.png"),
        ),
      ),
    );
  }
}
