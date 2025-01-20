import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/core/theme/text_form_field_themes.dart';
import 'package:brew_it/core/theme/text_themes.dart';
import 'package:flutter/material.dart';

ThemeData baseTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 183, 114, 58)),
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: baseTextTheme,
    appBarTheme: AppBarTheme(color: secondaryLighterColor),
    inputDecorationTheme: baseTextFormFieldTheme,
    disabledColor: textDarkColor);
