import 'package:brew_it/core/theme/button_themes.dart';
import 'package:brew_it/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  MainButton(this.content,
      {this.type = "default",
      this.navigateToPage,
      this.dataForPage,
      this.customOnPressed,
      this.formKey,
      this.apiCall,
      this.apiCallType,
      this.pop = false,
      this.navigateIsTablePage = false,
      super.key});

  final String content;
  final String type;
  final Function? navigateToPage;
  final Map? dataForPage;
  final Function? customOnPressed;
  final GlobalKey<FormState>? formKey;
  final String? apiCall;
  final String? apiCallType;
  final bool pop;
  final bool navigateIsTablePage;

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
          if (formKey != null && apiCall != null && navigateToPage != null) {
            formKey!.currentState!.save();
            try {
              final response;
              List? responseData;
              if (apiCallType == "put") {
                response = await getIt<Dio>().put(
                  apiCall!,
                  data: dataForPage,
                );
              } else if (apiCallType == "post_use_response_data") {
                response = await getIt<Dio>().post(
                  apiCall!,
                  data: dataForPage,
                );
                responseData = response.data;
              } else {
                response = await getIt<Dio>().post(
                  apiCall!,
                  data: dataForPage,
                );
              }
              if (response.statusCode == 200 || response.statusCode == 201) {
                if (apiCallType == "post_use_response_data") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return navigateToPage!(dataForPage, responseData);
                  }));
                } else if (navigateIsTablePage) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return navigateToPage!();
                  }));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return navigateToPage!(dataForPage);
                  }));
                }
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
          } else if (pop) {
            Navigator.pop(context);
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
