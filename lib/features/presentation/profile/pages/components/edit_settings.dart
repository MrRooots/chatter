import 'package:chatter/core/themes/palette.dart';
import 'package:chatter/features/domain/common/entities/user_entity.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_settings/edit_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSettingsPage extends StatefulWidget {
  static const String routeName = '/editSettings';

  const EditSettingsPage({super.key});

  @override
  State<EditSettingsPage> createState() => _EditSettingsPageState();
}

class _EditSettingsPageState extends State<EditSettingsPage> {
  late bool darkTheme;
  late bool showOnboarding;
  late bool receiveNotifications;
  late UserEntity user;

  @override
  void initState() {
    super.initState();

    user = BlocProvider.of<AuthenticationBloc>(context).currentUser;
    print(user.settings);
    darkTheme = user.settings.darkTheme;
    showOnboarding = user.settings.showOnboarding;
    receiveNotifications = user.settings.receiveNotifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal settings'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: 0.01,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy',
              textAlign: TextAlign.left,
              style: TextStyle(color: Palette.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Allow notifications'),
                BlocConsumer<EditSettingsBloc, EditSettingsState>(
                  listener: (context, state) {
                    if (state.isSuccess) {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(AuthenticationUpdated(newUser: state.user!));
                    }
                  },
                  builder: (context, state) {
                    return Switch(
                      value: receiveNotifications,
                      onChanged: (final bool value) {
                        setState(() => receiveNotifications = value);
                        BlocProvider.of<EditSettingsBloc>(context).add(
                          EditSettingsStart(
                            user: user,
                            darkTheme: darkTheme,
                            showOnboarding: showOnboarding,
                            receiveNotifications: value,
                          ),
                        );
                      },
                      activeColor: Palette.lightGreenSalad,
                      inactiveThumbColor: Palette.black,
                      inactiveTrackColor: Palette.lightRed,
                      // This is called when the user toggles the switch.
                    );
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(height: 32.0, color: Palette.lightGreenSalad),
            ),
            const Text(
              'Personalization',
              textAlign: TextAlign.left,
              style: TextStyle(color: Palette.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Show onboarding on startup'),
                BlocBuilder<EditSettingsBloc, EditSettingsState>(
                  builder: (context, state) {
                    return Switch(
                      value: showOnboarding,
                      onChanged: (final bool value) {
                        showOnboarding = value;
                        BlocProvider.of<EditSettingsBloc>(context).add(
                          EditSettingsStart(
                            user: user,
                            darkTheme: darkTheme,
                            showOnboarding: value,
                            receiveNotifications: receiveNotifications,
                          ),
                        );
                      },
                      activeColor: Palette.lightGreenSalad,
                      inactiveThumbColor: Palette.black,
                      inactiveTrackColor: Palette.lightRed,
                      // This is called when the user toggles the switch.
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark theme'),
                BlocBuilder<EditSettingsBloc, EditSettingsState>(
                  builder: (context, state) {
                    return Switch(
                      value: darkTheme,
                      onChanged: (final bool value) {
                        darkTheme = value;
                        BlocProvider.of<EditSettingsBloc>(context).add(
                          EditSettingsStart(
                            user: user,
                            darkTheme: value,
                            showOnboarding: showOnboarding,
                            receiveNotifications: receiveNotifications,
                          ),
                        );
                      },
                      activeColor: Palette.lightGreenSalad,
                      inactiveThumbColor: Palette.black,
                      inactiveTrackColor: Palette.lightRed,
                      // This is called when the user toggles the switch.
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
