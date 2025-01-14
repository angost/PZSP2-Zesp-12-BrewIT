import 'package:brew_it/core/helper/field_names.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

void handleApiError(BuildContext context, DioException e, Map<String, String>? errorMessages) {
  final detail = e.response?.data['detail'];
  if (errorMessages != null && detail != null && errorMessages!.containsKey(detail)) {
    showErrorDialog(context, errorMessages![detail]!);
  } else {
    showErrorDialog(context, "An unknown error occurred. Please try again.");
  }
}

void handleMultipleErrors(BuildContext context, DioException e, Map<String, String>? errorMessages) {
  // Extract errors from the response
  final errorData = e.response?.data as Map<String, dynamic>?;

  if (errorData != null) {
    // Collect all error messages
    final List<String> aggregatedErrors = [];
    errorData.forEach((field, messages) {
      if (messages is List && messages.isNotEmpty) {
        final translatedMessage = errorMessages![field];
        if (translatedMessage != null) {
          aggregatedErrors.add(translatedMessage);
        } else {
          aggregatedErrors.add("$field: ${messages.first}");
        }
      }
    });

    // Show all errors in a single dialog
    if (aggregatedErrors.isNotEmpty) {
      showErrorDialog(context, aggregatedErrors.join("\n"));
    }
  } else {
    showErrorDialog(context, "An unknown error occurred. Please try again.");
  }
}