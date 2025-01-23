import 'package:brew_it/core/theme/button_themes.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/errors/error_handlers.dart';
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
      this.errorMessages,
      this.customErrorHandler,
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
  final Map<String, dynamic>? errorMessages;
  final Function(BuildContext context, DioException e,
      Map<String, dynamic>? errorMessages)? customErrorHandler;

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
                }else if (apiCallType == "put") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return navigateToPage!(dataForPage);
                  }));
                } else {
                  showErrorDialog(context, "Navigation failed: No valid page.");
                }
              } else {
                print("An error occured");
              }
            } on DioException catch (e) {
              if (customErrorHandler != null) {
                customErrorHandler!(context, e, errorMessages);
              } else {
                handleApiError(context, e, errorMessages);
              }
            }
          } else if (navigateToPage != null) {
            final nextPage = dataForPage != null
                ? navigateToPage!(dataForPage)
                : navigateToPage!();
            if (nextPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextPage),
              );
            } else {
              // showErrorDialog(context, "Navigation failed: No valid page.");
            }
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

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

}
