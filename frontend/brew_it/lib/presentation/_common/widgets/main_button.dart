import 'package:brew_it/core/theme/button_themes.dart';
import 'package:brew_it/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class MainButton extends StatelessWidget {
  MainButton(this.content,
      {this.type = "default",
      this.navigateToPage,
      this.dataForPage,
      this.customOnPressed,
      this.formKey,
      this.apiCall,
      this.apiCallType,
      super.key});

  final String content;
  final String type;
  final Function? navigateToPage;
  final Map? dataForPage;
  final Function? customOnPressed;
  final GlobalKey<FormState>? formKey;
  final String? apiCall;
  final String? apiCallType;

  final typeToStyle = {
    "default": secondaryButtonTheme,
    "primary_big": primaryButtonTheme,
    "primary_small": primarySmallButtonTheme,
    "secondary_big": secondaryButtonTheme,
    "secondary_small": secondarySmallButtonTheme,
  };

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (formKey != null && apiCall != null) {
            formKey!.currentState!.save();
            try {
              final response;
              if (apiCallType == "put") {
                response = await getIt<Dio>().put(
                  apiCall!,
                  data: dataForPage,
                );
              } else {
                response = await getIt<Dio>().post(
                  apiCall!,
                  data: dataForPage,
                );
              }
              if (response.statusCode == 200 || response.statusCode == 201) {
                // MOCK? Create add/edit template which has standart apiCallType and accepted status code
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return navigateToPage!(dataForPage);
                }));
              } else {
                print("An error occured");
              }
            } on DioException catch (e) {
              print("An error occured");
            }
          } else if (navigateToPage != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (dataForPage != null) {
                try {
                  return navigateToPage!(dataForPage);
                } catch (e) {
                  return navigateToPage!();
                }
              } else {
                return navigateToPage!();
              }
            }));
          } else if (customOnPressed != null) {
            customOnPressed!();
          }
        },
        style: typeToStyle.containsKey(type)
            ? typeToStyle[type]!.style
            : typeToStyle["default"]!.style,
        child: Text(content));
  }
}
