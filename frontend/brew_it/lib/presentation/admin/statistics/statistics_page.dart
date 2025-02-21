import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_details_page.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_sum_page.dart';
import 'package:brew_it/injection_container.dart';
import 'package:dio/dio.dart';

class StatisticsPage extends TablePageTemplate {
  StatisticsPage({super.key})
      : super(
          title: "Statystyki szczegółowe:",
          buttons: [
            MainButton(
              "Statystyki łączne",
              type: "secondary_small",
              navigateToPage: () {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: _fetchCombinedStatistics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return StatisticsSumPage(snapshot.data!);
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                );
              },
            )
          ],
          options: null,
          headers: StatisticsFieldNames().fieldNamesTable,
          apiString: "/statistics/",
          jsonFields: StatisticsFieldNames().jsonFieldNamesTable,
          hideFirstField: true,
        );

  static Future<Map<String, dynamic>?> _fetchCombinedStatistics() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/statistics/combined/');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        debugPrint('Error fetching statistics: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception fetching statistics: $e');
      return null;
    }
  }
}



