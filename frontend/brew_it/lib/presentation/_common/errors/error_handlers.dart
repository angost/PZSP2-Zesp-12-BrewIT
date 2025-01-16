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

void handleApiError(BuildContext context, DioException e, Map<String, dynamic>? errorMessages) {
  final detail = e.response?.data['detail'];
  if (errorMessages != null && detail != null && errorMessages!.containsKey(detail)) {
    showErrorDialog(context, errorMessages![detail]!);
  } else {
    showErrorDialog(context, "An unknown error occurred. Please try again.");
  }
}

void handleMultipleErrors(
    BuildContext context, DioException e, Map<String, dynamic>? errorMessages) {
  // Extract errors from the response
  final errorData = e.response?.data as Map<String, dynamic>?;

  if (errorData != null) {
    final List<String> aggregatedErrors = [];

    // Recursive lookup for messages
    String? translateMessage(String field, dynamic message) {
      final entry = errorMessages?[field];
      if (entry is Map) {
        for (final key in entry.keys) {
          if (RegExp(key).hasMatch(message)) {
            return entry[key];
          }
        }
      } else if (entry is String) {
        // Simple string: Return the translation
        return entry;
      }
      return "$field: $message"; // Fallback: Use raw message
    }

    // Process each error field
    errorData.forEach((field, messages) {
      if (messages is List && messages.isNotEmpty) {
        for (final message in messages) {
          final translatedMessage = translateMessage(field, message);
          aggregatedErrors.add(translatedMessage ?? message);
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
