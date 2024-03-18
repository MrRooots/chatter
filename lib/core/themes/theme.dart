import 'package:chatter/core/themes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Main application theme
final class MyTheme {
  static final ThemeData baseTheme = ThemeData(
    fontFamily: 'Nunito',
    fontFamilyFallback: const ['Roboto'],
    useMaterial3: true,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    iconTheme: const IconThemeData(color: Palette.black, size: 16.0),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Palette.black, size: 16.0),
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        color: Palette.black,
        fontFamily: 'Nunito',
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Palette.lightGrey,
        statusBarBrightness: Brightness.light,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Palette.lightGreenSalad,
    ),
    scaffoldBackgroundColor: Palette.lightGrey,
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: Palette.black,
      floatingLabelStyle: TextStyle(color: Palette.green),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.lightGreenSalad, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.lightGreenSalad, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.red, width: 2),
      ),
      errorStyle: TextStyle(fontSize: 14.0),
      focusColor: Palette.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Palette.lightGreenSalad,
    ),
  );

  static final ThemeData darkTheme = baseTheme.copyWith(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(color: Palette.white, size: 16.0),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Palette.white, size: 16.0),
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        color: Palette.white,
        fontFamily: 'Nunito',
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Palette.black,
        statusBarBrightness: Brightness.light,
      ),
    ),
  );

  static final ThemeData lightTheme = baseTheme.copyWith(
    brightness: Brightness.light,
  );
}
