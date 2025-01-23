import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/brewery_data/brewery_data_edit_page.dart';
import 'package:brew_it/presentation/commercial/home_page_commercial.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';

class BreweryDataPage extends DetailsAddEditPageTemplate {
  BreweryDataPage(Map elementData, {super.key})
      : super(
            title: "Dane browaru:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return HomePageCommercial();
                },
              )
            ],
            options: [
              MyIconButton(
                type: "edit",
                navigateToPage: (Map elementData) {
                  return BreweryDataEditPage(elementData);
                },
                dataForPage: elementData,
              ),
            ],
            fieldNames: BreweryDataFieldNames().fieldNames,
            jsonFieldNames: BreweryDataFieldNames().jsonFieldNames,
            hideFirstField: true,
            elementData: elementData);
}

Function navigateToBreweryDataPage = () {
  return FutureBuilder<Map<String, dynamic>?>(
    future: _fetchBreweryData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        return BreweryDataPage(snapshot.data!);
      } else {
        return const Center(child: Text('No data available'));
      }
    },
  );
};

Future<Map<String, dynamic>?> _fetchBreweryData() async {
  try {
    final dio = getIt<Dio>();
    final response = await dio.get('/breweries/me/');
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      debugPrint('Error fetching brewery data: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Exception brewery data: $e');
    return null;
  }
}
