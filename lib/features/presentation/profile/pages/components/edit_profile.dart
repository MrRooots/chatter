import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/widgets/default_button.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatelessWidget {
  static const routeName = '/editProfile';

  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: 0.01,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: EditProfileBody(
                user: BlocProvider.of<AuthenticationBloc>(context).currentUser,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  final UserEntity user;

  const EditProfileBody({super.key, required this.user});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  bool isPasswordHide = true;

  String get firstName => _firstNameController.text.trim();

  String get lastName => _lastNameController.text.trim();

  String get username => _emailController.text.trim();

  String get status => _statusController.text.trim();

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.user.firstname;
    _lastNameController.text = widget.user.lastname;
    _emailController.text = widget.user.email;
    _statusController.text = widget.user.status;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _statusController.dispose();

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
                      'Edit your profile',
                      style: TextStyle(fontSize: 32.0),
                    ),
                    Text(
                      'Information',
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
              _buildTextInput(
                controller: _firstNameController,
                label: 'First name',
                hint: 'Enter first name...',
              ),
              const SizedBox(height: 8.0),
              _buildTextInput(
                controller: _lastNameController,
                label: 'Last name',
                hint: 'Enter last name...',
              ),
              const SizedBox(height: 8.0),
              _buildTextInput(
                controller: _statusController,
                label: 'Status',
                hint: 'Set your status...',
              ),
              const SizedBox(height: 8.0),
              _buildTextInput(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter email...',
                isEditable: false,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        BlocConsumer<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) => current.isSuccess,
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
                        BlocProvider.of<EditProfileBloc>(context).add(
                      EditProfileStart(
                        user: BlocProvider.of<AuthenticationBloc>(context)
                            .currentUser,
                        firstname: firstName,
                        lastname: lastName,
                        status: status,
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

  TextFormField _buildTextInput({
    required TextEditingController controller,
    bool isEditable = true,
    required final String label,
    required final String hint,
    final Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: const TextStyle(decoration: TextDecoration.none),
      // keyboardType: isEditable ? TextInputType.emailAddress : null,
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 32.0,
          maxWidth: 32.0,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
