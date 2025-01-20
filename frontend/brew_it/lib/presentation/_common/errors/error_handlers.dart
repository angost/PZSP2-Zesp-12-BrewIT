import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Uwaga!"),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

void handleApiError(
    BuildContext context, DioException e, Map<String, dynamic>? errorMessages) {
  final detail = e.response?.data['detail'];
  if (errorMessages != null &&
      detail != null &&
      errorMessages!.containsKey(detail)) {
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
      } else if (messages.isNotEmpty) {
        final translatedMessage = translateMessage(field, messages);
        aggregatedErrors.add(translatedMessage ?? messages);
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
