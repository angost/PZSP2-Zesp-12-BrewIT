import 'package:brew_it/core/theme/button_themes.dart';
import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  MyIconButton({
    this.type = "default",
    this.navigateToPage,
    this.dataForPage,
    this.customOnPressed,
    this.apiCall,
    this.apiCallType,
    this.apiIdName,
    this.elementId,
    this.filtersData,
    super.key,
  });

  final String type;
  final Function? navigateToPage;
  final Map? dataForPage;
  final Function? customOnPressed;
  final String? apiCall;
  final String? apiCallType;
  final String? apiIdName;
  final int? elementId;
  final Map? filtersData;

  final typeToIcon = {
    "default": Icons.info_outline,
    "add": Icons.add,
    "edit": Icons.edit,
    "save": Icons.save,
    "delete": Icons.delete,
    "accept": Icons.check_circle_outline_outlined,
    "cancel": Icons.cancel_outlined,
    "time": Icons.schedule,
    "info": Icons.info_outline,
    "link": Icons.link,
    "configure": Icons.settings,
  };

  final typeToColor = {
    "default": greyLightColor,
    "delete": errorTransparentColor,
    "accept": primaryTransparentColor,
    "cancel": errorTransparentColor,
  };

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        try {
          if (apiCall != null && (apiCallType == "post" || apiCallType == "delete")) {
            final response = await _performApiCall();
            if (response.statusCode == 201 || response.statusCode == 204) {
              // Successful API call, navigate to the page
              _navigateToPage(context);
            } else {
              // Handle unexpected status codes
              _showErrorDialog(context, "Unexpected response from the server.");
            }
          } else if (navigateToPage != null && filtersData != null) {
            // Navigate with filters
            _navigateToPageWithFilters(context);
          } else if (navigateToPage != null) {
            // Navigate without API
            _navigateToPage(context);
          } else if (customOnPressed != null) {
            // Custom button action
            customOnPressed!();
          }
        } on DioException catch (e) {
          // Handle specific Dio errors
          _handleApiError(context, e);
        } catch (e) {
          // General error handler
          _showErrorDialog(context, "An unexpected error occurred.");
        }
      },
      style: iconButtonTheme.style!.copyWith(
        backgroundColor: WidgetStatePropertyAll(
          typeToColor[type] ?? typeToColor["default"],
        ),
      ),
      icon: Icon(typeToIcon[type] ?? typeToIcon["default"]),
    );
  }

  Future<Response> _performApiCall() async {
    if (apiCallType == "post") {
      return await getIt<Dio>().post(apiCall!, data: {apiIdName: elementId});
    } else {
      return await getIt<Dio>().delete("${apiCall!}$elementId/");
    }
  }

  void _navigateToPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return dataForPage != null ? navigateToPage!(dataForPage) : navigateToPage!();
      }),
    );
  }

  void _navigateToPageWithFilters(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return navigateToPage!(dataForPage, filtersData);
      }),
    );
  }

  void _handleApiError(BuildContext context, DioException e) {
    if (e.response?.statusCode == 400) {
      final detail = e.response?.data['detail'];
      if (detail == 'Cannot delete equipment with active reservations.') {
        _showErrorDialog(context, "Nie można usunąć urządzenia, ponieważ ma aktywne rezerwacje.");
      } else if (detail == 'Cannot delete equipment with active reservation requests.') {
        _showErrorDialog(context, "Nie można usunąć urządzenia, ponieważ ma aktywne żądania rezerwacji.");
      } else {
        _showErrorDialog(context, "Nie udało się usunąć obiektu. Jest powiązany z innym.");
      }
    } else {
      _showErrorDialog(context, "Błąd połączenia z serwerem.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Błąd"),
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
}