import 'package:brew_it/core/theme/button_themes.dart';
import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MenuLogoutButton extends StatelessWidget {
  const MenuLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          try {
            final response = await getIt<Dio>().post(
              "/logout/",
            );

            if (response.statusCode == 200) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LogInPage();
              }));
            } else {
              print("An error occured");
            }
          } on DioException catch (e) {
            print("An error occured");
          }
        },
        style: tertiaryButtonTheme.style!.copyWith(
            backgroundColor: WidgetStateProperty.all(errorTransparentColor)),
        child: const Text("Wyloguj się"));
  }
}
