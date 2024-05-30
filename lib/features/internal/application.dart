import 'dart:developer';

import 'package:chatter/core/themes/theme.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/common/pages/splash.dart';
import 'package:chatter/router.dart';
import 'package:chatter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessengerApp extends StatelessWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('Main app build called', name: 'Application');

    return BlocProvider.value(
      value: sl.get<AuthenticationBloc>()..add(const AuthenticationStart()),
      child: MaterialApp(
        title: 'Chatter',
        theme: MyTheme.baseTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashPage.routeName,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
