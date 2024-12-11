import 'package:brew_it/core/theme/theme_constants.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewIT Demo',
      theme: baseTheme,
      home: const LogInPage(),
    );
  }
}
