import 'package:chatter/features/internal/application.dart';
import 'package:chatter/firebase_options.dart';
import 'package:chatter/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDependencies();

  runApp(const MessengerApp());
}
